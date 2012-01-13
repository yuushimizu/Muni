Lifegame = {};
(function() {
    var forEach = function(fn, array) {
        var i = 0;
        var l = array.length;
        for (; i < l; ++i) fn(array[i]);
    };
    var indexOf = function(x, array) {
        var i = 0;
        var l = array.length;
        for (; i < l; ++i) if (array[i] == x) return i;
        return null;
    };
    var filtered = function(fn, array) {
        var result = [];
        forEach(function(e) {
            if (fn(e)) result.push(e);
        }, array);
        return result;
    };
    var removed = function(fn, array) {
        return filtered(function(e) {return !fn(e)}, array);
    };
    var sorted = function(fn, array) {
        var result = [];
        forEach(function(e) {
            result.push(e);
        }, array);
        result.sort(fn);
        return result;
    };
    var randomInt = function(min, max) {
        return min + Math.floor(Math.random() * (max - min + 1));
    };
    var randomBool = function() {
        return randomInt(0, 1) == 0;
    };
    var randomRadian = function() {
        return Math.random() * Math.PI * 2;
    };
    var randomPoint = function(minX, maxX, minY, maxY) {
        return {
            x: randomInt(minX, maxX),
            y: randomInt(minY, maxY)
        };
    };
    var manhattanDistance = function(source, destination) {
        return {
            x: destination.x - source.x,
            y: destination.y - source.y
        };
    };
    var distanceFromManhattanDistance = function(manhattanDistance) {
        if (manhattanDistance.x == 0) return Math.abs(manhattanDistance.y);
        if (manhattanDistance.y == 0) return Math.abs(manhattanDistance.x);
        return Math.abs(manhattanDistance.x / Math.sin(Math.atan2(manhattanDistance.x, manhattanDistance.y)));
    };
    var pointsDistance = function(point1, point2) {
        return distanceFromManhattanDistance(manhattanDistance(point1, point2));
    };
    var radianFromPoints = function(source, destination) {
        var md = manhattanDistance(source, destination);
        return Math.atan2(md.x, md.y);
    };
    var manhattanDistanceFromRadian = function(radian, distance) {
        return {
            x: Math.sin(radian) * distance,
            y: Math.cos(radian) * distance
        };
    };
    var movedPointWithRadian = function(source, radian, distance) {
        var md = manhattanDistanceFromRadian(radian, distance);
        return {
            x: source.x + md.x,
            y: source.y + md.y
        };
    };
    var movedPointForDestination = function(source, destination, moveRange) {
        var md = manhattanDistance(source, destination);
        var distance = distanceFromManhattanDistance(md);
        if (moveRange >= distance) return destination;
        if (source.x == destination.x) {
            step = {x: 0, y: (source.y > destination.y ? -moveRange : moveRange)};
        } else if (source.y == destination.y) {
            step = {x: (source.x > destination.x ? -moveRange : moveRange), y: 0};
        } else {
            step = manhattanDistanceFromRadian(Math.atan2(md.x, md.y), moveRange);
        }
        return {
            x: source.x + step.x,
            y: source.y + step.y
        };
    };
    var cellRadius = function(cell) {
        return cell.vitality.max / 1000;
    };
    var moveCell = function(cell, destination, field) {
        oldPoint = {x: cell.x, y: cell.y};
        cell.x = destination.x < 0 ? 0 : (destination.x > field.width ? field.width : destination.x);
        cell.y = destination.y < 0 ? 0 : (destination.y > field.height ? field.height : destination.y);
        return pointsDistance(oldPoint, cell);
    };
    var randomPointOnField = function(field) {
        return randomPoint(0, field.width, 0, field.height);
    };
    var cellsInRange = function(point, range, game) {
        var result = [];
        forEach(function(other) {
            var distance = pointsDistance(point, other) - cellRadius(other);
            if (distance <= range) result.push({cell: other, distance: distance});
        }, game.cells);
        return result;
    };
    var movingMethod = {
        immovable: function() {
            return function(cell, game) {
                return 0;
            };
        },
        randomDestination: function() {
            var destination;
            var resetDestination = function(game) {
                destination = randomPointOnField(game.field);
            };
            return function(cell, game) {
                if (destination == undefined || (cell.x == destination.x && cell.y == destination.y)) resetDestination(game);
                return moveCell(cell, movedPointForDestination(cell, destination, cell.moveRange), game.field);
            };
        },
        bound: function() {
            var radian = randomRadian();
            return function(cell, game) {
                var destination = movedPointWithRadian(cell, radian, cell.moveRange);
                if (destination.x <= 0 || destination.x >= game.field.width) {
                    radian = Math.PI * 2 - radian;
                }
                if (destination.y <= 0 || destination.y >= game.field.height) {
                    radian = Math.PI - radian;
                    while (radian < 0) radian += Math.PI * 2;
                }
                return moveCell(cell, destination, game.field);
            };
        },
        furafura: function() {
            return function(cell, game) {
                var currentDistance = Math.random() * cell.moveRange;
                var destination = movedPointWithRadian(cell, randomRadian(), currentDistance);
                var distance = moveCell(cell, destination, game.field);
                return distance;
            };
        },
        searchNearest: function(isTarget, whenFound, whenAlone) {
            return function(cell, game) {
                var searchResults = cellsInRange(cell, cell.searchRange, game);
                searchResults.sort(function(result1, result2) {return result1.distance - result2.distance});
                var i = 0;
                var l = searchResults.length;
                for (; i < l; ++i) {
                    if (searchResults[i].cell == cell || !isTarget(searchResults[i].cell)) continue;
                    return whenFound(cell, searchResults[i].cell, game);
                }
                return whenAlone(cell, game);
            };
        },
        tail: function(isTarget, whenAlone) {
            return movingMethod.searchNearest(isTarget, function(cell, target, game) {
                return moveCell(cell,
                                movedPointForDestination(cell, target, cell.moveRange),
                                game.field);
            }, whenAlone);
        },
        escape: function(isTarget, whenAlone) {
            return movingMethod.searchNearest(isTarget, function(cell, target, game) {
                return moveCell(cell,
                                movedPointWithRadian(cell, radianFromPoints(target, cell), cell.moveRange),
                                game.field);
            }, whenAlone);
        }
    };
    var cellFrame = function(cell, game) {
        if (cell.vitality.current <= 0) return;
        var movedDistance = cell.movingMethod.instance(cell, game);
        cell.lastMovedDistance = movedDistance;
        cell.vitality.current -= movedDistance * cell.weight / 2;
        cell.vitality.current -= cell.weight;
    };
    var cellsFrame = function(game) {
        game.cells = removed(function(cell) {return cell.vitality.current <= 0}, game.cells);
        forEach(function(cell) {cellFrame(cell, game)}, game.cells);
    };
    var makeGame = function(field) {
        var game = {
            field: field,
            cells: [],
            frameCount: 0
        };
        Lifegame.game = game;
        var i;
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 8000, current: 8000},
                             weight: 5,
                             movingMethod: {
                                 source: movingMethod.randomDestination,
                                 instance: movingMethod.randomDestination()
                             },
                             moveRange: 2,
                             searchRange: 40,
                             color: {red: 0, green: 0, blue: 169}});
        }
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 4000, current: 4000},
                             weight: 1,
                             movingMethod: {
                                 source: movingMethod.bound,
                                 instance: movingMethod.bound()
                                 },
                             moveRange: 3,
                             searchRange: 20,
                             color: {red: 210, green: 210, blue: 210}});
        }
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 3500, current: 3500},
                             weight: 2,
                             movingMethod: {
                                 source: movingMethod.furafura,
                                 instance: movingMethod.furafura()
                             },
                             moveRange: 0.5,
                             searchRange: 60,
                             color: {red: 255, green: 240, blue: 180}});
        }
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 3000, current: 3000},
                             weight: 2,
                             movingMethod: {
                                 source: movingMethod.immovable,
                                 instance: movingMethod.immovable()
                             },
                             moveRange: 0,
                             searchRange: 200,
                             color: {red: 10, green: 197, blue: 120}});
        }
        for (i = 0; i < 5; i++) {
            var initialPoint = randomPointOnField(game.field);
            var tailMovingCell = function() {
                return movingMethod.tail(function(cell) {
                    return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                }, movingMethod.furafura());
            };
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 5000, current: 5000},
                             weight: 3,
                             movingMethod: {
                                 source: tailMovingCell,
                                 instance: tailMovingCell()
                             },
                             moveRange: 1.5,
                             searchRange: 160,
                             color: {red: 220, green: 80, blue: 220}});
        }
        return game;
    };
    var changeGameField = function(game, field) {
        game.field = field;
        game.cells = removed(function(cell) {
            return cell.x > field.width || cell.y > field.height;
        }, game.cells);
    };
    var resetCanvasSize = function(canvas, game) {
        canvas.style.width = game.field.width + 'px';
        canvas.style.height = game.field.height + 'px';
        canvas.width = game.field.width;
        canvas.height = game.field.height;
    };
    Lifegame.run = function(canvas, configuration) {
        var game = makeGame(configuration.field);
        resetCanvasSize(canvas, game);
        var frameRate = 0;
        var monitorFrameRate = (function() {
            var lastTime = (new Date).getTime();
            var lastFrameCount = 0;
            return function() {
                var currentTime = (new Date).getTime();
                var currentFrames = game.frameCount;
                var frames = currentFrames - lastFrameCount;
                frameRate = frames == 0 ? 0 : Math.round(frames / ((currentTime - lastTime) / 1000));
                lastTime = currentTime;
                lastFrameCount = currentFrames;
                setTimeout(monitorFrameRate, 1000);
            };
        })();
        monitorFrameRate();
        var context = canvas.getContext('2d');
        var transform = {
            x: 0,
            y: 0,
            rate: 1
        };
        var zoomContext = function(x, y, rate) {
            transform.x = x;
            transform.y = y;
            transform.rate = rate;
            var area = {
                width: game.field.width / rate,
                height: game.field.height / rate
            };
            var origin = {
                x: x - area.width / 2,
                y: y - area.height / 2
            };
            if (origin.x < 0) {
                origin.x = 0;
            } else if (origin.x + area.width >= game.field.width) {
                origin.x = game.field.width - area.width;
            }
            if (origin.y < 0) {
                origin.y = 0;
            } else if (origin.y + area.height >= game.field.height) {
                origin.y = game.field.height - area.height;
            }
            context.setTransform(rate, 0, 0, rate, -origin.x * rate, -origin.y * rate);
        };
        var resetZoom = function() {
            return zoomContext(0, 0, 1);
        };
        var clearField = function() {
            context.clearRect(0, 0, game.field.width, game.field.height);
        };
        var cellAlpha = function(cell) {
            return 0.1 + (cell.vitality.current / cell.vitality.max);
        };
        var setDrawingCellStyle = function(cell) {
            if (cell.vitality.current <= 0) {
                context.lineWidth = cellRadius(cell);
                context.strokeStyle = 'rgba(0,0,0,0.9)';
                context.fillStyle = 'rgba(0,0,0,0)';
            } else {
                context.lineWidth = cell.weight / 2;
                var alpha = cellAlpha(cell);
                context.strokeStyle = 'rgba(0,0,0,' + (alpha + 0.5) + ')';
                context.fillStyle = 'rgba(' + cell.color.red + ',' + cell.color.green + ',' + cell.color.blue + ',' + alpha + ')';
            }
        };
        var drawCell = function(cell) {
            context.beginPath();
            setDrawingCellStyle(cell);
            context.arc(cell.x, cell.y, cellRadius(cell), 0, Math.PI * 2, false);
            context.fill();
            context.stroke();
        };
        var drawCells = function() {
            forEach(drawCell, sorted(function(cell1, cell2) {return cellRadius(cell2) - cellRadius(cell1)}, game.cells));
        };
        var drawGameInformation = function() {
            context.save();
            context.setTransform(1, 0, 0, 1, 0, 0);
            context.beginPath();
            context.fillStyle = 'rgb(255,255,255)';
            var text = 'Zoom: x' + transform.rate + ' Frame: ' + game.frameCount + ' Cells: ' + game.cells.length + ' FPS: ' + frameRate;
            var x = 3;
            var y = 3;
            context.textBaseline = 'top';
            context.fillText(text, x, y);
            context.restore();
        };
        var redraw = function(game) {
            clearField();
            drawCells();
            drawGameInformation();
        };
        var running = true;
        var targetFPS = configuration.fps;
        var frame = function() {
            var startTime = (new Date).getTime();
            redraw(game);
            if (running) {
                cellsFrame(game);
                game.frameCount++;
                setTimeout(frame, 1000 / targetFPS - ((new Date).getTime() - startTime));
            } else {
                setTimeout(frame, 100);
            }
        };
        frame();
        return {
            toggleRunning: function() {
                running = !running;
            },
            stop: function() {
                running = false;
            },
            resume: function() {
                running = true;
            },
            reset: function() {
                game = makeGame(game.field);
            },
            changeField: function(field) {
                changeGameField(game, field);
                resetCanvasSize(canvas, game);
            },
            changeFPS: function(fps) {
                targetFPS = fps;
            },
            zoom: function(x, y, rate) {
                zoomContext(x, y, rate);
            },
            isZoomed: function() {
                return transform.rate != 1;
            },
            resetZoom: function() {
                resetZoom();
            }
        };
    };
}());

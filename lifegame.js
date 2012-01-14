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
    var randomFetch = function(array) {
        return array[randomInt(0, array.length - 1)];
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
    var cellWeight = function(cell) {
        return cellRadius(cell) * cell.density;
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
        cell.event = null;
        if (cell.vitality.current <= 0) return;
        var movedDistance = cell.movingMethod.instance(cell, game);
        cell.lastMovedDistance = movedDistance;
        cell.vitality.current -= movedDistance * cellWeight(cell) / 5;
        cell.vitality.current -= cellWeight(cell) / 10;
        cell.message = Math.floor(cell.vitality.current) + '/' + Math.floor(cell.vitality.max);
    };
    var cellsFrame = function(game) {
        game.cells = removed(function(cell) {return cell.vitality.current <= 0}, game.cells);
        forEach(function(cell) {cellFrame(cell, game)}, game.cells);
    };
    var makeRandomCell = function(field) {
        var initialPoint = randomPointOnField(field);
        var vitality = 1000 + randomInt(1, 10) * randomInt(1, 100) * randomInt(1, 100);
        var makeRandomMovingMethod = function() {
            return randomFetch([
                function() {return movingMethod.immovable},
                function() {return movingMethod.randomDestination},
                function() {return movingMethod.bound},
                function() {return movingMethod.furafura},
                function() {
                    var whenAlone = makeRandomMovingMethod()();
                    return function() {
                        return movingMethod.tail(function(cell) {
                            return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                        }, whenAlone);
                    };
                },
                function() {
                    var whenAlone = makeRandomMovingMethod()();
                    return function() {
                        return movingMethod.escape(function(cell) {
                            return true;
                        }, whenAlone);
                    };
                }])();
        };
        var moving = makeRandomMovingMethod();
        var rgbRate = {red: Math.random(), green: Math.random(), blue: Math.random()};
        if (rgbRate.red == 0 && rgbRate.green == 0 && rgbRate.blue == 0) rgbRate = {red: 1, green: 1, blue: 1};
        return {x: initialPoint.x,
                y: initialPoint.y,
                vitality: {max: vitality, current: vitality},
                density: 0.1 + Math.random() * 1.9,
                movingMethod: {source: moving, instance: moving()},
                moveRange: randomInt(0, 5),
                searchRange: randomInt(0, 300),
                rgbRate: rgbRate};
    };
    var gameFrame = function(game) {
        cellsFrame(game);
        game.frameCount++;
        if (randomInt(0, game.cells.length) == 0) {
            var newCell = makeRandomCell(game.field);
            newCell.event = 'born';
            game.cells.push(newCell);
        }
    };
    var makeGame = function(field) {
        var game = {
            field: field,
            cells: [],
            frameCount: 0
        };
        Lifegame.game = game;
        var i;
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 8000, current: 8000},
                             density: 1,
                             movingMethod: {
                                 source: movingMethod.randomDestination,
                                 instance: movingMethod.randomDestination()
                             },
                             moveRange: 2,
                             searchRange: 40,
                             rgbRate: {red: 0, green: 0, blue: 1}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            var tailMovingCell = function() {
                return movingMethod.tail(function(cell) {
                    return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                }, movingMethod.randomDestination());
            };
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 80000, current: 80000},
                             density: 2,
                             movingMethod: {
                                 source: tailMovingCell,
                                 instance: tailMovingCell()
                             },
                             moveRange: 1,
                             searchRange: 100,
                             rgbRate: {red: 3, green: 2, blue: 1}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 4000, current: 4000},
                             density: 0.2,
                             movingMethod: {
                                 source: movingMethod.bound,
                                 instance: movingMethod.bound()
                                 },
                             moveRange: 3,
                             searchRange: 20,
                             rgbRate: {red: 1, green: 1, blue: 2}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 3500, current: 3500},
                             density: 1,
                             movingMethod: {
                                 source: movingMethod.furafura,
                                 instance: movingMethod.furafura()
                             },
                             moveRange: 0.5,
                             searchRange: 60,
                             rgbRate: {red: 1, green: 1, blue: 0}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 3000, current: 3000},
                             density: 0.75,
                             movingMethod: {
                                 source: movingMethod.immovable,
                                 instance: movingMethod.immovable()
                             },
                             moveRange: 0,
                             searchRange: 200,
                             rgbRate: {red: 0, green: 3, blue: 1}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            var tailMovingCell = function() {
                return movingMethod.tail(function(cell) {
                    return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                }, movingMethod.furafura());
            };
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 5000, current: 5000},
                             density: 0.8,
                             movingMethod: {
                                 source: tailMovingCell,
                                 instance: tailMovingCell()
                             },
                             moveRange: 1.5,
                             searchRange: 160,
                             rgbRate: {red: 2, green: 1, blue: 2}});
        }
        for (i = 0; i < 0; i++) {
            game.cells.push(makeRandomCell(game.field));
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
        var drawCell = function(cell) {
            var radius = cellRadius(cell);
            if (cell.event != undefined && cell.event == 'born') {
                context.beginPath();
                context.strokeStyle = 'rgba(255,255,255,0.5)';
                context.lineWidth = radius;
                context.fillStyle = 'rgba(255, 255, 255, 255)';
                context.arc(cell.x, cell.y, radius, 0, Math.PI * 2, false);
                context.closePath();
                context.fill();
                context.stroke();
            } else if (cell.vitality.current <= 0) {
                context.beginPath();
                context.lineWidth = radius;
                context.strokeStyle = 'rgba(0,0,0,0.9)';
                context.fillStyle = 'rgba(0,0,0,0)';
                context.arc(cell.x, cell.y, radius, 0, Math.PI * 2, false);
                context.closePath();
                context.stroke();
            } else {
                var alpha = cellAlpha(cell);
                context.beginPath();
                context.strokeStyle = 'rgba(0,0,0,' + (alpha + 0.5) + ')';
                context.lineWidth = 1;
                var rgbRateTotal = cell.rgbRate.red + cell.rgbRate.green + cell.rgbRate.blue;
                var adjustColor = function(source) {
                    var rated = Math.floor(255 * source / rgbRateTotal + 96);
                    var adjusted = Math.floor(rated < 0 ? 0 : (rated > 255 ? 255 : rated) + 96 - (96 * ((cell.density - 1) * 1.5 + 1)));
                    return adjusted < 0 ? 0 : (adjusted > 255 ? 255 : adjusted);
                };
                var ratedColor = {
                    red: adjustColor(cell.rgbRate.red),
                    green: adjustColor(cell.rgbRate.green),
                    blue: adjustColor(cell.rgbRate.blue)};
                context.fillStyle = 'rgba(' + ratedColor.red + ',' + ratedColor.green + ',' + ratedColor.blue + ',' + alpha + ')';
                context.arc(cell.x, cell.y, radius, 0, Math.PI * 2, false);
                context.closePath();
                context.fill();
                context.stroke();
                context.fillStyle = 'rgb(255,255,255)';
            }
            if (cell.message != undefined && cell.message != "") {
                context.textBaseline = 'top';
                context.textAlign = 'center';
                context.fillText(cell.message, cell.x, cell.y + radius + 1);
            }
        };
        var drawCells = function() {
            forEach(drawCell, sorted(function(cell1, cell2) {return cellRadius(cell2) - cellRadius(cell1)}, game.cells));
        };
        var drawGameInformation = function() {
            context.save();
            context.setTransform(1, 0, 0, 1, 0, 0);
            context.fillStyle = 'rgb(255,255,255)';
            var text = 'Zoom: x' + transform.rate + ' Frame: ' + game.frameCount + ' Cells: ' + game.cells.length + ' FPS: ' + frameRate;
            var x = 3;
            var y = 3;
            context.textBaseline = 'top';
            context.textAlign = 'left';
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
                gameFrame(game);
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

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
    var filter = function(fn, array) {
        var result = [];
        forEach(function(e) {
            if (fn(e)) result.push(e);
        }, array);
        return result;
    };
    var removeIf = function(fn, array) {
        return filter(function(e) {return !fn(e)}, array);
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
        if (manhattanDistance.x == 0) return manhattanDistance.y;
        if (manhattanDistance.y == 0) return manhattanDistance.x;
        return Math.abs(manhattanDistance.x / Math.sin(Math.atan2(manhattanDistance.x, manhattanDistance.y)));
    };
    var pointsDistance = function(point1, point2) {
        return distanceFromManhattanDistance(manhattanDistance(point1, point2));
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
    var movedPointForDestination = function(source, destination, movableDistance) {
        var md = manhattanDistance(source, destination);
        var distance = distanceFromManhattanDistance(md);
        if (movableDistance >= distance) return destination;
        if (source.x == destination.x) {
            step = {x: 0, y: (source.y > destination.y ? -movableDistance : movableDistance)};
        } else if (source.y == destination.y) {
            step = {x: (source.x > destination.x ? -movableDistance : movableDistance), y: 0};
        } else {
            step = manhattanDistanceFromRadian(Math.atan2(md.x, md.y), movableDistance);
        }
        return {
            x: source.x + step.x,
            y: source.y + step.y
        };
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
            var distance = pointsDistance(point, other) - other.size;
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
                return moveCell(cell, movedPointForDestination(cell, destination, cell.movableDistance), game.field);
            };
        },
        bound: function() {
            var radian = randomRadian();
            return function(cell, game) {
                var destination = movedPointWithRadian(cell, radian, cell.movableDistance);
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
                var currentDistance = Math.random() * cell.movableDistance;
                var destination = movedPointWithRadian(cell, randomRadian(), currentDistance);
                var distance = moveCell(cell, destination, game.field);
                return distance;
            };
        },
        tail: function(isTarget, whenAlone) {
            return function(cell, game) {
                var searchResults = cellsInRange(cell, cell.searchRange, game);
                searchResults.sort(function(result1, result2) {return result1.distance - result2.distance});
                var i = 0;
                var l = searchResults.length;
                for (; i < l; ++i) {
                    if (searchResults[i].cell == cell || !isTarget(searchResults[i].cell)) continue;
                    return moveCell(cell,
                                    movedPointForDestination(cell, searchResults[i].cell, cell.movableDistance),
                                    game.field);
                }
                return whenAlone(cell, game);
            };
        }
    };
    var cellFrame = function(cell, game) {
        if (cell.vitality.current <= 0) return;
        var movedDistance = cell.movingMethod.instance(cell, game);
        cell.lastMovedDistance = movedDistance;
        cell.vitality.current -= movedDistance;
        cell.vitality.current -= cell.fixedCost;
    };
    var cellsFrame = function(game) {
        game.cells = removeIf(function(cell) {return cell.vitality.current <= 0}, game.cells);
        forEach(function(cell) {cellFrame(cell, game)}, game.cells);
    };
    var configuration = {
        process: {
            defaultDelay: 30
        },
        field: {
            width: 960,
            height: 480
        }
    };
    var makeGame = function() {
        var game = {
            field: configuration.field,
            cells: [],
            frameCount: 0
        };
        Lifegame.game = game;
        var i;
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             size: 6,
                             vitality: {max: 10000, current: 10000},
                             movingMethod: {
                                 source: movingMethod.randomDestination,
                                 instance: movingMethod.randomDestination()
                             },
                             movableDistance: 2,
                             searchRange: 20,
                             fixedCost: 8,
                             color: {red: 0, green: 0, blue: 169}});
        }
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             size: 3,
                             vitality: {max: 7000, current: 7000},
                             movingMethod: {
                                 source: movingMethod.bound,
                                 instance: movingMethod.bound()
                                 },
                             movableDistance: 3,
                             searchRange: 10,
                             fixedCost: 3,
                             color: {red: 210, green: 210, blue: 210}});
        }
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             size: 4,
                             vitality: {max: 2500, current: 2500},
                             movingMethod: {
                                 source: movingMethod.furafura,
                                 instance: movingMethod.furafura()
                             },
                             movableDistance: 0.5,
                             searchRange: 30,
                             fixedCost: 1,
                             color: {red: 255, green: 240, blue: 180}});
        }
        for (i = 0; i < 10; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             size: 3,
                             vitality: {max: 3000, current: 3000},
                             movingMethod: {
                                 source: movingMethod.immovable,
                                 instance: movingMethod.immovable()
                             },
                             movableDistance: 0,
                             searchRange: 100,
                             fixedCost: 2,
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
                             size: 3,
                             vitality: {max: 8000, current: 8000},
                             movingMethod: {
                                 source: tailMovingCell,
                                 instance: tailMovingCell()
                             },
                             movableDistance: 1.5,
                             searchRange: 80,
                             fixedCost: 4,
                             color: {red: 220, green: 80, blue: 220}});
        }
        return game;
    };
    var initializeCanvas = function(canvas, game) {
        canvas.style.width = game.field.width + 'px';
        canvas.style.height = game.field.height + 'px';
        canvas.width = game.field.width;
        canvas.height = game.field.height;
    };
    Lifegame.run = function(canvas) {
        var game = makeGame();
        initializeCanvas(canvas, game);
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
        var clearField = function() {
            context.clearRect(0, 0, game.field.width, game.field.height);
        };
        var cellColor = function(cell) {
            var alpha = 0.1 + (cell.vitality.current / cell.vitality.max);
            return 'rgba(' + cell.color.red + ',' + cell.color.green + ',' + cell.color.blue + ',' + alpha + ')';
        };
        var setDrawingCellStyle = function(cell) {
            if (cell.vitality.current <= 0) {
                context.lineWidth = cell.size;
                context.strokeStyle = 'rgba(0,0,0,0.9)';
                context.fillStyle = 'rgba(0,0,0,0)';
            } else {
                context.lineWidth = 1;
                context.strokeStyle = 'rgba(0,0,0,0.8)';
                context.fillStyle = cellColor(cell);
            }
        };
        var drawCell = function(cell) {
            context.beginPath();
            setDrawingCellStyle(cell);
            context.arc(cell.x, cell.y, cell.size, 0, Math.PI * 2, false);
            context.fill();
            context.stroke();
        };
        var drawGameInformation = function(game) {
            context.save();
            context.setTransform(1, 0, 0, 1, 0, 0);
            context.beginPath();
            context.fillStyle = 'rgb(255,255,255)';
            var text = 'x' + transform.rate + ' Frame: ' + game.frameCount + ' Cells: ' + game.cells.length;
            var x = 3;
            var y = 3;
            context.textBaseline = 'top';
            context.fillText(text, x, y);
            context.restore();
        };
        var redraw = function(game) {
            clearField();
            forEach(drawCell, game.cells);
            drawGameInformation(game);
        };
        var running = true;
        var delay = configuration.process.defaultDelay;
        var frame = function() {
            redraw(game);
            if (running) {
                cellsFrame(game);
                game.frameCount++;
                setTimeout(frame, delay);
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
                game = makeGame();
            },
            changeDelay: function(newDelay) {
                delay = newDelay;
            },
            zoom: function(x, y, rate) {
                zoomContext(x, y, rate);
            },
            isZoomed: function() {
                return transform.rate != 1;
            },
            resetZoom: function() {
                zoomContext(0, 0, 1);
            }
        };
    };
}());

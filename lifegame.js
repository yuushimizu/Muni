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
    var removeIf = function(fn, array) {
        var i = array.length - 1;
        for (; i >= 0; --i) {
            if (fn(array[i])) {
                array.splice(i, 1);
                --i;
            }
        }
    };
    var randomInt = function(min, max) {
        return min + Math.floor(Math.random() * (max - min + 1));
    };
    var randomBool = function() {
        return randomInt(0, 1) == 0;
    }
    var randomPoint = function(minX, maxX, minY, maxY) {
        return {
            x: randomInt(minX, maxX),
            y: randomInt(minY, maxY)
        };
    };
    var manhattanDiff = function(point1, point2) {
        return {
            x: point1.x - point2.x,
            y: point1.y - point2.y
        };
    };
    var moveStepFor = function(source, destination, totalStep) {
        var diff = manhattanDiff(destination, source);
        var distance = {
            x: Math.abs(diff.x),
            y: Math.abs(diff.y)
        };
        var totalDistance = distance.x + distance.y;
        var stepDistance;
        if (distance.x == 0) {
            stepDistance = {
                x: 0,
                y: totalStep <= distance.y ? totalStep : distance.y
            };
        } else {
            stepDistance = {x: Math.floor(totalStep * distance.x / totalDistance)};
            if (stepDistance.x > distance.x) {
                stepDistance.x = distance.x;
            }
            stepDistance.y = totalStep - stepDistance.x;
            if (stepDistance.y > distance.y) {
                stepDistance.y = distance.y;
                if (stepDistance.x < distance.x) {
                    var restDistance = totalStep - stepDistance.y - stepDistance.x;
                    if (distance.x - stepDistance.x <= restDistance) {
                        stepDistance.x = distance.x;
                    } else {
                        stepDistance.x += restDistance;
                    }
                }
            }
        }
        return {
            x: diff.x > 0 ? stepDistance.x : -stepDistance.x,
            y: diff.y > 0 ? stepDistance.y : -stepDistance.y
        };
    }
    var moveCell = function(cell, step, field) {
        oldPoint = {x: cell.x, y: cell.y};
        cell.x += step.x;
        cell.y += step.y;
        if (cell.x < 0) {
            cell.x = 0;
        } else if (cell.x >= field.width) {
            cell.x = field.width - 1;
        }
        if (cell.y < 0) {
            cell.y = 0;
        } else if (cell.y >= field.height) {
            cell.y = field.height - 1;
        }
        return {x: Math.abs(cell.x - oldPoint.x), y: Math.abs(cell.y - oldPoint.y)};
    }
    var randomPointOnField = function(field) {
        return randomPoint(0, field.width - 1, 0, field.height - 1);
    }
    var movingMethod = {
        randomDestination: function() {
            var destination;
            var resetDestination = function(field) {
                destination = randomPointOnField(field);
            };
            return function(cell, field) {
                if (destination == undefined || (cell.x == destination.x && cell.y == destination.y)) resetDestination(field);
                return moveCell(cell, moveStepFor(cell, destination, cell.step), field);
            };
        },
        bound: function() {
            var rate = {x: randomInt(0, 20), y: randomInt(0, 20)};
            if (rate.x == 0 && rate.y == 0) rate = {x: 1, y: 1};
            var inversion = {x: randomBool(), y: randomBool()};
            return function(cell, field) {
                var step = {x: Math.floor(cell.step * rate.x / (rate.x + rate.y)),
                            y: Math.floor(cell.step * rate.y / (rate.y + rate.y))};
                var movedDistance = moveCell(cell,
                                             {x: inversion.x ? -step.x : step.x,
                                              y: inversion.y ? -step.y : step.y},
                                             field);
                if (cell.x <= 0 || cell.x >= field.width - 1) inversion.x = !inversion.x;
                if (cell.y <= 0 || cell.y >= field.height - 1) inversion.y = !inversion.y;
                return movedDistance;
            };
        },
        chorochoro: function() {
            return function(cell, field) {
                var currentStep = randomInt(0, cell.step);
                var step = {x: randomInt(0, cell.step)};
                step.y = currentStep - step.x;
                if (randomBool()) step.x = -step.x;
                if (randomBool()) step.y = -step.y;
                return moveCell(cell, step, field);
            };
        }
    };
    var cellFrame = function(cell, game) {
        if (cell.vitality.current < 0) return;
        var movedDistance = cell.movingMethod.instance(cell, game.field);
        cell.vitality.current -= (movedDistance.x + movedDistance.y);
    };
    var cellsFrame = function(game) {
        removeIf(function(cell) {return cell.vitality.current <= 0}, game.cells);
        forEach(function(cell) {
            cellFrame(cell, game);
        }, game.cells);
    };
    var configuration = {
        process: {
            delay: 30
        },
        field: {
            width: 960,
            height: 480
        },
        color: {
            cellBorder: 'rgba(0,0,0,0.8)'
        }
    };
    var makeGame = function() {
        var game = {
            field: configuration.field,
            cells: []
        };
        var i;
        for (i = 0; i < 30; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             size: 6,
                             vitality: {max: 4000, current: 4000},
                             movingMethod: {
                                 source: movingMethod.randomDestination,
                                 instance: movingMethod.randomDestination()
                             },
                             step: 4,
                             color: {red: 0, green: 0, blue: 169}});
        }
        for (i = 0; i < 50; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             size: 3,
                             vitality: {max: 3000, current: 3000},
                             movingMethod: {
                                 source: movingMethod.bound,
                                 instance: movingMethod.bound()
                                 },
                             step: 6,
                             color: {red: 210, green: 210, blue: 210}});
        }
        for (i = 0; i < 20; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                                 y: initialPoint.y,
                             size: 4,
                             vitality: {max: 1500, current: 1500},
                             movingMethod: {
                                 source: movingMethod.chorochoro,
                                 instance: movingMethod.chorochoro()
                             },
                             step: 1,
                             color: {red: 255, green: 240, blue: 180}});
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
        var clearField = function() {
            context.clearRect(0, 0, game.field.width, game.field.height);
        };
        var cellColor = function(cell) {
            if (cell.vitality.current <= 0) return 'rgba(0,0,0,1)';
            return 'rgba(' + cell.color.red + ',' + cell.color.green + ',' + cell.color.blue + ',' + (cell.vitality.current / cell.vitality.max) + ')';
        }
        var drawCell = function(cell) {
            context.beginPath();
            context.strokeStyle = configuration.color.cellBorder;
            context.fillStyle = cellColor(cell);
            context.arc(cell.x, cell.y, cell.size, 0, Math.PI * 2, false);
            context.fill();
            context.stroke();
        };
        var redraw = function(game) {
            clearField();
            forEach(drawCell, game.cells);
        };
        var running = true;
        var frame = function() {
            redraw(game);
            if (running) {
                cellsFrame(game);
            }
            setTimeout(function() {frame()}, configuration.process.delay);
        };
        frame();
        return {
            toggleRunning: function() {
                running = !running;
            },
            reset: function() {
                game = makeGame();
            }
        };
    };
}());

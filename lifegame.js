Lifegame = {};
(function() {
    var copyObject = function(obj) {
        var result = {};
        for (var key in obj) result[key] = obj[key];
        return result;
    };
    var copyArray = function(array) {
        var result = [];
        for (var i = 0, l = array.length; i < l; ++i) {
            result.push(array[i]);
        }
        return result;
    }
    var indexOf = function(x, array) {
        var i = 0;
        var l = array.length;
        for (; i < l; ++i) if (array[i] == x) return i;
        return null;
    };
    var filtered = function(fn, array) {
        var result = [];
        for (var i = 0, l = array.length; i < l; ++i) {
            if (fn(array[i])) result.push(array[i]);
        }
        return result;
    };
    var sorted = function(fn, array) {
        var result = copyArray(array);
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
    var fixRadian = function(radian) {
        while (radian < 0) radian += Math.PI * 2;
        while (radian > Math.PI * 2) radian -= Math.PI * 2;
        return radian;
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
        return fixRadian(Math.atan2(md.x, md.y));
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
        var cells = game.cells;
        for (var i = 0, l = cells.length; i < l; ++i) {
            var other = cells[i];
            var distance = pointsDistance(point, other) - cellRadius(other);
            if (distance <= range) result.push({cell: other, distance: distance});
        }
        return result;
    };
    var cellType = function(cell) {
        var rgbRate = cell.rgbRate;
        var total = rgbRate.red + rgbRate.green + rgbRate.blue;
        var adjusted = {
            red: rgbRate.red / total,
            green: rgbRate.green / total,
            blue: rgbRate.blue / total
        };
        if (adjusted.red >= 0.33) {
            if (adjusted.green >= 0.33) {
                if (adjusted.blue >= 0.33) {
                    return 'gray';
                } else {
                    return 'yellow';
                }
            } else if (adjusted.blue >= 0.33) {
                return 'purple';
            } else {
                return 'red';
            }
        } else if (adjusted.green >= 0.33) {
            if (adjusted.blue >= 0.33) {
                return 'teal';
            } else {
                return 'green';
            }
        } else {
            return 'blue';
        }
    };
    var isEatingTarget = function(cell, other) {
        return cellType(cell) != cellType(other);
    };
    var movingMethod = {
        immovable: function() {
            return function(cell, game) {
                return 0;
            };
        },
        toDestination: function(nextDestination) {
            var destination;
            return function(cell, game) {
                if (destination == undefined || (cell.x == destination.x && cell.y == destination.y)) destination = nextDestination(cell, game);
                return moveCell(cell, movedPointForDestination(cell, destination, cell.moveRange), game.field);
            };
        },
        randomDestination: function() {
            return movingMethod.toDestination(function(cell, game) {
                return randomPointOnField(game.field);
            });
        },
        furafura: function() {
            return movingMethod.toDestination(function(cell, game) {
                var destination = movedPointWithRadian(cell, randomRadian(), Math.random() * cellRadius(cell) * 10);
                return {
                    x: destination.x < 0 ? 0 : (destination.x > game.field.width ? game.field.width : destination.x),
                    y: destination.y < 0 ? 0 : (destination.y > game.field.height ? game.field.height : destination.y)
                };
            });
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
        circle: function() {
            var radian = randomRadian();
            var increase = Math.random() / 2;
            if (randomBool()) increase = -increase;
            return function(cell, game) {
                var destination = movedPointWithRadian(cell, radian, cell.moveRange);
                radian = fixRadian(radian + increase);
                return moveCell(cell, destination, game.field);
            };
        },
        chorochoro: function() {
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
                    if (searchResults[i].cell == cell || !isTarget(cell, searchResults[i].cell)) continue;
                    return whenFound(cell, searchResults[i].cell, game);
                }
                return whenAlone(cell, game);
            };
        },
        moon: function(isTarget, radianIncrease, distance, whenAlone) {
            var increase = radianIncrease;
            var radian = undefined;
            return movingMethod.searchNearest(isTarget, function(cell, target, game) {
                var currentDistance = pointsDistance(target, cell);
                if (currentDistance - cell.moveRange > distance) {
                    radian = radianFromPoints(target, cell);
                    return moveCell(cell, movedPointForDestination(cell, target, cell.moveRange), game.field);
                } else {
                    var currentRadian = radianFromPoints(target, cell);
                    if (radian == undefined) radian = currentRadian;
                    var destination = movedPointWithRadian(target, radian, distance);
                    var movedPoint = movedPointForDestination(cell, destination, cell.moveRange);
                    if (destination.x == movedPoint.x && destination.y == movedPoint.y) {
                        radian += increase;
                    }
                    var oldPosition = {x: cell.x, y: cell.y};
                    var movedDistance = moveCell(cell, movedPoint, game.field);
                    if (oldPosition.x == cell.x || oldPosition.y == cell.y) {
                        increase *= -1;
                        radian += increase;
                    }
                    return movedDistance;
                }
            }, whenAlone);
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
    var copyCell = function(cell) {
        var copy = copyObject(cell);
        copy.vitality = copyObject(cell.vitality);
        copy.movingMethod = copyObject(cell.movingMethod);
        copy.movingMethod.instance = copy.movingMethod.source();
        copy.specialActions = copyArray(cell.specialActions);
        copy.rgbRate = copyObject(cell.rgbRate);
        return copy;
    };
    var specialActions = {
        multiply: function(cell, game) {
            if (randomInt(0, 500) != 0) return;
            var cost = cell.vitality.max * 0.2;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var child = copyCell(cell);
            var radius = cellRadius(cell);
            moveCell(child, movedPointWithRadian(cell, randomRadian(), radius * 2 + Math.random() * radius * 2), game.field);
            child.event = 'born';
            child.parent = cell;
            game.cells.push(child);
        },
        shot: function(cell, game) {
            if (randomInt(0, 1000) != 0) return;
            var cost = cell.vitality.max / 1000;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var shot = copyCell(cell);
            shot.vitality.max *= 0.1;
            shot.vitality.current = shot.vitality.max * 0.1;
            shot.movingMethod.source = movingMethod.bound;
            shot.movingMethod.instance = movingMethod.bound();
            shot.moveRange = 2 + shot.moveRange / 2;
            shot.specialActions = [];
            shot.event = 'born';
            shot.parent = cell;
            game.cells.push(shot);
        },
        makeMoon: function(cell, game) {
            if (randomInt(0, 1000) != 0) return;
            var cost = cell.vitality.max / 10;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var moon = copyCell(cell);
            moon.vitality.max *= 0.3;
            moon.vitality.current = moon.vitality.max;
            var radianIncrease = (0.01 + Math.random() * 0.5) * (randomBool() ? 1 : -1);
            var radius = cellRadius(cell);
            var distance = radius + cellRadius(moon) + Math.random() * radius * 2;
            var moving = function() {return movingMethod.moon(function(moon, target) {return target == cell}, radianIncrease, distance, movingMethod.circle())};
            moveCell(moon, movedPointWithRadian(cell, randomRadian(), distance), game.field);
            moon.movingMethod.source = moving;
            moon.movingMethod.instance = moving();
            moon.moveRange = (moon.moveRange + 0.5) * 2;
            moon.searchRange = game.field.width > game.field.height ? game.field.width : game.field.height;
            moon.specialActions = [];
            moon.event = 'born';
            moon.parent = cell;
            game.cells.push(moon);
        },
        split: function(cell, game) {
            if (randomInt(0, 500) != 0) return;
            if (cell.vitality.max < 5000) {
                return;
            }
            cell.vitality.current /= 2;
            cell.vitality.max /= 2;
            var parts = [copyCell(cell), copyCell(cell)];
            cell.vitality.current = 0;
            var distance = cellWeight(cell) / 2;
            for (var i = 0, l = parts.length; i < l; ++i) {
                var part = parts[i];
                part.event = 'born';
                moveCell(part, movedPointWithRadian(part, randomRadian(), distance), game.field);
                game.cells.push(part);
            }
        }
    };
    var cellMovingFrame = function(cell, game) {
        var movedDistance = cell.movingMethod.instance(cell, game);
        cell.lastMovedDistance = movedDistance;
        cell.vitality.current -= movedDistance * cellWeight(cell) / 5 + cellWeight(cell) / 10;
    };
    var cellEatingFrame = function(cell, game) {
        var hittingCells = cellsInRange(cell, cellRadius(cell), game);
        var i = 0;
        var l = hittingCells.length;
        for (; i < l; ++i) {
            var hittingCell = hittingCells[i].cell;
            if (hittingCell == cell || !isEatingTarget(cell, hittingCell) || hittingCell.vitality.current <= 0) continue;
            var damage = cell.density * ((cell.lastMovedDistance == undefined ? 0 : cell.lastMovedDistance) + 1) * 100;
            damage -= damage * hittingCell.density / 10;
            if (damage > 0) {
                hittingCell.vitality.current -= damage;
                hittingCell.event = 'damaged';
                knockedPositionBase = hittingCell.knockedPosition == undefined ? hittingCell : hittingCell.knockedPosition;
                hittingCell.knockedPosition = movedPointWithRadian(knockedPositionBase, radianFromPoints(cell, knockedPositionBase), damage / 100);
                if (hittingCell.vitality.current <= 0) {
                    cell.vitality.current += hittingCells[i].cell.vitality.max;
                    cell.event = 'healed';
                    if (cell.vitality.current > cell.vitality.max) cell.vitality.current = cell.vitality.max;
                }
            }
        }
    };
    var cellsFrame = function(game) {
        game.cells = filtered(function(cell) {return cell.vitality.current > 0}, game.cells);
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            cell.event = undefined;
            cellMovingFrame(cell, game);
        }
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            cellEatingFrame(cell, game);
            cell.message = cellType(cell) + ' ' + Math.ceil(cell.vitality.current / 10) + '/' + Math.ceil(cell.vitality.max / 10);
        }
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            if (cell.knockedPosition != undefined) {
                moveCell(cell, cell.knockedPosition, game.field);
                cell.knockedPosition = undefined;
            }
        }
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            for (var actionIndex = 0, actionCount = cell.specialActions.length; actionIndex < actionCount; ++actionIndex) {
                cell.specialActions[actionIndex](cell, game);
            }
        }
    };
    var makeRandomCell = function(field) {
        var initialPoint = randomPointOnField(field);
        var vitality = 1000 + randomInt(1, 10) * randomInt(1, 100) * randomInt(1, 100);
        var makeRandomTargetFunction = function() {
            return randomFetch([
                function(cell, other) {
                    // all
                    return true;
                },
                isEatingTarget,
                function(cell, other) {
                    // not eating target.
                    return !isEatingTarget(cell, other);
                },
                function(cell, other) {
                    // faster than me.
                    return other.lastMovedDistance != undefined && (cell.lastMovedDistance == undefined || cell.lastMovedDistance < other.lastMovedDistance);
                },
                function(cell, other) {
                    // slower than me.
                    return cell.lastMovedDistance != undefined && (other.lastMovedDistance == undefined || cell.lastMovedDistance >= other.lastMovedDistance);
                },
                function(cell, other) {
                    // larger than me.
                    return cellRadius(cell) < cellRadius(other);
                },
                function(cell, other) {
                    // smaller than me.
                    return cellRadius(cell) >= cellRadius(other);
                },
                function(cell, other) {
                    // unmoved.
                    return cell.lastMovedDistance != undefined || cell.lastMovedDistance == 0;
                }]);
        };
        var makeRandomMovingMethod = function() {
            return randomFetch([
                function() {return movingMethod.immovable},
                function() {return movingMethod.randomDestination},
                function() {return movingMethod.furafura},
                function() {return movingMethod.bound},
                function() {return movingMethod.circle},
                function() {return movingMethod.chorochoro},
                function() {
                    var whenAlone = makeRandomMovingMethod()();
                    return function() {
                        return movingMethod.moon(makeRandomTargetFunction(), Math.random() / 2, Math.random() * 10, whenAlone);
                    };
                },
                function() {
                    var whenAlone = makeRandomMovingMethod()();
                    return function() {
                        return movingMethod.tail(makeRandomTargetFunction(), whenAlone);
                    };
                },
                function() {
                    var whenAlone = makeRandomMovingMethod()();
                    return function() {
                        return movingMethod.escape(makeRandomTargetFunction(), whenAlone);
                    };
                }])();
        };
        var moving = makeRandomMovingMethod();
        var actions = filtered(randomBool, [specialActions.multiply, specialActions.shot, specialActions.makeMoon, specialActions.split]);
        var rgbRate = {red: Math.random(), green: Math.random(), blue: Math.random()};
        if (rgbRate.red == 0 && rgbRate.green == 0 && rgbRate.blue == 0) rgbRate = {red: 1, green: 1, blue: 1};
        return {x: initialPoint.x,
                y: initialPoint.y,
                vitality: {max: vitality, current: vitality},
                density: 0.1 + Math.random() * 1.9,
                movingMethod: {source: moving, instance: moving()},
                specialActions: actions,
                moveRange: 0.01 + randomInt(0, 2) * randomInt(0, 2) + randomInt(0, 1),
                searchRange: randomInt(0, 300),
                rgbRate: rgbRate};
    };
    var gameFrame = function(game) {
        cellsFrame(game);
        game.frameCount++;
        if (randomInt(0, game.cells.length * 2) == 0) {
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
                                 source: movingMethod.circle,
                                 instance: movingMethod.circle()
                             },
                             specialActions: [specialActions.makeChild],
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
                             specialActions: [],
                             moveRange: 1,
                             searchRange: 100,
                             rgbRate: {red: 1, green: 0.5, blue: 0.3}});
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
                             specialActions: [],
                             moveRange: 3,
                             searchRange: 20,
                             rgbRate: {red: 0.5, green: 0.5, blue: 1}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 3500, current: 3500},
                             density: 1,
                             movingMethod: {
                                 source: movingMethod.chorochoro,
                                 instance: movingMethod.chorochoro()
                             },
                             specialActions: [],
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
                             specialActions: [],
                             moveRange: 0,
                             searchRange: 200,
                             rgbRate: {red: 0, green: 1, blue: 0.3}});
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            var tailMovingCell = function() {
                return movingMethod.tail(function(cell) {
                    return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                }, movingMethod.chorochoro());
            };
            game.cells.push({x: initialPoint.x,
                             y: initialPoint.y,
                             vitality: {max: 5000, current: 5000},
                             density: 0.8,
                             movingMethod: {
                                 source: tailMovingCell,
                                 instance: tailMovingCell()
                             },
                             specialActions: [],
                             moveRange: 1.5,
                             searchRange: 160,
                             rgbRate: {red: 1, green: 0.5, blue: 1}});
        }
        for (i = 0; i < 0; i++) {
            game.cells.push(makeRandomCell(game.field));
        }
        return game;
    };
    var changeGameField = function(game, field) {
        game.field = field;
        game.cells = filtered(function(cell) {
            return cell.x < field.width && cell.y < field.height;
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
                if (cell.event == 'damaged') {
                    context.strokeStyle = 'rgba(196,0,0,1)';
                    context.lineWidth = 2;
                } else if (cell.event == 'healed') {
                    context.strokeStyle = 'rgba(0, 196, 196, 0.8)';
                    context.lineWidth = 3;
                } else {
                    context.strokeStyle = 'rgba(0,0,0,' + (alpha + 0.5) + ')';
                    context.lineWidth = 1;
                }
                var rgbRateTotal = cell.rgbRate.red + cell.rgbRate.green + cell.rgbRate.blue;
                var adjustColor = function(source) {
                    var rated = Math.floor(255 * source / rgbRateTotal + 96);
                    var adjusted = Math.floor(rated < 0 ? 0 : (rated > 255 ? 255 : rated) + 80 - (96 * cell.density));
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
            }
            if (cell.message != undefined && cell.message != "") {
                context.fillStyle = 'rgba(255,255,255,1)';
                context.textBaseline = 'top';
                context.textAlign = 'center';
                context.fillText(cell.message, cell.x, cell.y + radius + 1);
            }
        };
        var drawCells = function() {
            var sortedCells = sorted(function(cell1, cell2) {return cellRadius(cell2) - cellRadius(cell1)}, game.cells);
            for (var i = 0, l = sortedCells.length; i < l; ++i) drawCell(sortedCells[i]);
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

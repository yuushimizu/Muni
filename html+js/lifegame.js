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
    var randomFloat = function(min, max) {
        return min + Math.random() * (max - min);
    };
    var randomInt = function(min, max) {
        return min + Math.floor(Math.random() * (max - min));
    };
    var randomFetch = function(array) {
        return array[randomInt(0, array.length)];
    };
    var randomBool = function() {
        return randomInt(0, 2) == 0;
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
            x: randomFloat(minX, maxX),
            y: randomFloat(minY, maxY)
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
    var cellsSpacialIndexKeysInCircle = function(origin, radius, game) {
        var index = game.cellsSpacialIndex;
        var split = index.split;
        var field = game.field;
        var subWidth = field.width / split;
        var subHeight = field.height / split;
        var boundsKeys = {
            top: Math.floor((origin.y - radius) / subHeight),
            bottom: Math.floor((origin.y + radius) / subHeight),
            left: Math.floor((origin.x - radius) / subWidth),
            right: Math.floor((origin.x + radius) / subWidth)
        };
        if (boundsKeys.top < 0) {
            boundsKeys.top = 0;
        } else if (boundsKeys.top >= split) {
            boundsKeys.top = split - 1;
        }
        if (boundsKeys.bottom < 0) {
            boundsKeys.bottom = 0;
        } else if (boundsKeys.bottom >= split) {
            boundsKeys.bottom = split - 1;
        }
        if (boundsKeys.left < 0) {
            boundsKeys.left = 0;
        } else if (boundsKeys.left >= split) {
            boundsKeys.left = split - 1;
        }
        if (boundsKeys.right < 0) {
            boundsKeys.right = 0;
        } else if (boundsKeys.right >= split) {
            boundsKeys.right = split - 1;
        }
        var keys = [];
        if (boundsKeys.left == boundsKeys.right) {
            for (var yKey = boundsKeys.top; yKey <= boundsKeys.bottom; ++yKey) {
                keys.push({x: boundsKeys.left, y: yKey});
            }
        } else if (boundsKeys.top == boundsKeys.bottom) {
            for (var xKey = boundsKeys.left; xKey <= boundsKeys.right; ++xKey) {
                keys.push({x: xKey, y: boundsKeys.top});
            }
        } else {
            var originKey = {x: Math.floor(origin.x / subWidth), y: Math.floor(origin.y / subHeight)};
            for (var xKey = boundsKeys.left; xKey <= boundsKeys.right; ++xKey) {
                if (xKey == originKey.x) {
                    for (var yKey = boundsKeys.top; yKey <= boundsKeys.bottom; ++yKey) {
                        keys.push({x: xKey, y: yKey});
                    }
                } else {
                    var nearestX = xKey < originKey ? xKey * subWidth + subWidth : xKey * subWidth;
                    var topKey = originKey.y;
                    for (var yKey = boundsKeys.top; yKey < originKey.y; ++yKey) {
                        var gridBottom = yKey * subHeight + subHeight;
                        if (pointsDistance({x: nearestX, y: gridBottom}, origin) <= radius) {
                            topKey = yKey;
                            break;
                        }
                    }
                    var bottomKey = originKey.y;
                    for (var yKey = boundsKeys.bottom; yKey > originKey.y; --yKey) {
                        var gridTop = yKey * subHeight;
                        if (pointsDistance({x: nearestX, y: gridTop}, origin) <= radius) {
                            bottomKey = yKey;
                            break;
                        }
                    }
                    for (var yKey = topKey; yKey <= bottomKey; ++yKey) {
                        keys.push({x: xKey, y: yKey});
                    }
                }
            }
        }
        return keys;
    };
    var addCellToSpacialIndex = function(cell, game) {
        var keys = cellsSpacialIndexKeysInCircle(cell, cellRadius(cell), game);
        for (var i = 0, l = keys.length; i < l; ++i) {
            var key = keys[i];
            game.cellsSpacialIndex.grids[key.x][key.y].push(cell);
        }
        cell.spacialIndexKeys = keys;
    };
    var removeCellFromSpacialIndex = function(cell, game) {
        var keys = cell.spacialIndexKeys;
        if (keys == undefined) return;
        for (var i = 0, l = keys.length; i < l; ++i) {
            var key = keys[i];
            var grid = game.cellsSpacialIndex.grids[key.x][key.y];
            var cellIndex = indexOf(cell, grid);
            if (cellIndex != null) grid.splice(cellIndex, 1);
        }
        cell.spacialIndexKeys = undefined;
    };
    var fieldLimitGap = 0.0001;
    var moveCell = function(cell, destination, game) {
        removeCellFromSpacialIndex(cell, game);
        var field = game.field;
        oldPoint = {x: cell.x, y: cell.y};
        cell.x = destination.x < 0 ? 0 : (destination.x > field.width - fieldLimitGap ? field.width - fieldLimitGap : destination.x);
        cell.y = destination.y < 0 ? 0 : (destination.y > field.height - fieldLimitGap ? field.height -fieldLimitGap : destination.y);
        addCellToSpacialIndex(cell, game);
        return pointsDistance(oldPoint, cell);
    };
    var randomPointOnField = function(field) {
        return randomPoint(0, field.width, 0, field.height);
    };
    var addCellToGame = function(cell, game) {
        cell.id = game.nextCellID;
        game.nextCellID += 1;
        game.cells.push(cell);
        removeCellFromSpacialIndex(cell, game);
        addCellToSpacialIndex(cell, game);
    };
    var removeCellFromGame = function(cell, game) {
        removeCellFromSpacialIndex(cell, game);
        var index = indexOf(cell, game.cells);
        if (index != null) game.cells.splice(index, 1);
    };
    var cellsInSpacialIndex = function(keys, game) {
        var cells = [];
        for (var keyIndex = 0, keyCount = keys.length; keyIndex < keyCount; ++keyIndex) {
            var key = keys[keyIndex];
            var grid = game.cellsSpacialIndex.grids[key.x][key.y];
            for (var cellIndex = 0, cellCount = grid.length; cellIndex < cellCount; ++cellIndex) {
                var cell = grid[cellIndex];
                if (indexOf(cell, cells) == null) cells.push(cell);
            }
        }
        return cells;
    }
    var hittingCells = function(game) {
        var result = [];
        var hittingMap = {};
        var gridCount = game.cellsSpacialIndex.split;
        for (var xKey = 0; xKey < gridCount; ++xKey) {
            for (var yKey = 0; yKey < gridCount; ++yKey) {
                var grid = game.cellsSpacialIndex.grids[xKey][yKey];
                var cellCount = grid.length;
                for (var cellIndex1 = 0; cellIndex1 < cellCount; ++cellIndex1) {
                    var cell1 = grid[cellIndex1];
                    if (hittingMap[cell1.id] == undefined) hittingMap[cell1.id] = {};
                    var currentMap = hittingMap[cell1.id];
                    var radius1 = cellRadius(cell1);
                    for (var cellIndex2 = 0; cellIndex2 < cellCount; ++cellIndex2) {
                        var cell2 = grid[cellIndex2];
                        if (cell1.id >= cell2.id) continue;
                        if (currentMap[cell2.id] != undefined) continue;
                        if (pointsDistance(cell1, cell2) <= radius1 + cellRadius(cell2)) {
                            currentMap[cell2.id] = cell2;
                            result.push({cell1: cell1, cell2: cell2});
                        }
                    }
                }
            }
        }
        return result;
    };
    var cellsInRange = function(point, range, game) {
        var cells = cellsInSpacialIndex(cellsSpacialIndexKeysInCircle(point, range, game), game);
        var result = [];
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
        var has = {
            red: adjusted.red >= 0.32,
            green: adjusted.green >= 0.32,
            blue: adjusted.blue >= 0.32
        };
        if (has.red) {
            if (has.green) {
                if (has.blue) {
                    return 'gray';
                } else {
                    return 'yellow';
                }
            } else if (has.blue) {
                return 'purple';
            } else {
                return 'red';
            }
        } else if (has.green) {
            if (has.blue) {
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
                return moveCell(cell, movedPointForDestination(cell, destination, cell.moveRange), game);
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
                    x: destination.x < 0 ? 0 : (destination.x > game.field.width - fieldLimitGap ? game.field.width - fieldLimitGap : destination.x),
                    y: destination.y < 0 ? 0 : (destination.y > game.field.height - fieldLimitGap ? game.field.height - fieldLimitGap : destination.y)
                };
            });
        },
        bound: function() {
            var radian = randomRadian();
            return function(cell, game) {
                var destination = movedPointWithRadian(cell, radian, cell.moveRange);
                if (destination.x <= 0 || destination.x >= game.field.width - fieldLimitGap) {
                    radian = Math.PI * 2 - radian;
                }
                if (destination.y <= 0 || destination.y >= game.field.height - fieldLimitGap) {
                    radian = Math.PI - radian;
                    while (radian < 0) radian += Math.PI * 2;
                }
                return moveCell(cell, destination, game);
            };
        },
        circle: function() {
            var radian = randomRadian();
            var increase = Math.random() / 2;
            if (randomBool()) increase = -increase;
            return function(cell, game) {
                var destination = movedPointWithRadian(cell, radian, cell.moveRange);
                radian = fixRadian(radian + increase);
                return moveCell(cell, destination, game);
            };
        },
        chorochoro: function() {
            return function(cell, game) {
                var currentDistance = Math.random() * cell.moveRange;
                var destination = movedPointWithRadian(cell, randomRadian(), currentDistance);
                var distance = moveCell(cell, destination, game);
                return distance;
            };
        },
        searching: function(fn) {
            return function(cell, game) {
                return fn(cell, cellsInRange(cell, cell.searchRange, game), game);
            };
        },
        searchNearest: function(isTarget, whenFound, whenAlone) {
            return movingMethod.searching(function(cell, searchResults, game) {
                searchResults.sort(function(result1, result2) {return result1.distance - result2.distance});
                var i = 0;
                var l = searchResults.length;
                for (; i < l; ++i) {
                    if (searchResults[i].cell == cell || !isTarget(cell, searchResults[i].cell)) continue;
                    return whenFound(cell, searchResults[i].cell, game);
                }
                return whenAlone(cell, game);
            });
        },
        moon: function(isTarget, radianIncrease, distance, whenAlone) {
            var increase = radianIncrease;
            var radian = undefined;
            return movingMethod.searchNearest(isTarget, function(cell, target, game) {
                var currentDistance = pointsDistance(target, cell);
                var destinationDistance = cellRadius(target) + distance;
                if (currentDistance - cell.moveRange > destinationDistance) {
                    radian = radianFromPoints(target, cell);
                    return moveCell(cell, movedPointForDestination(cell, target, cell.moveRange), game);
                } else {
                    var currentRadian = radianFromPoints(target, cell);
                    if (radian == undefined) radian = currentRadian;
                    var destination = movedPointWithRadian(target, radian, destinationDistance);
                    var movedPoint = movedPointForDestination(cell, destination, cell.moveRange);
                    if (destination.x == movedPoint.x && destination.y == movedPoint.y) {
                        radian += increase;
                    }
                    var movedDistance = moveCell(cell, movedPoint, game);
                    if (movedPoint.x != cell.x || movedPoint.y != cell.y) {
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
                                game);
            }, whenAlone);
        },
        escape: function(isTarget, whenAlone) {
            return movingMethod.searchNearest(isTarget, function(cell, target, game) {
                return moveCell(cell,
                                movedPointWithRadian(cell, radianFromPoints(target, cell), cell.moveRange),
                                game);
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
            if (randomInt(0, 100) != 0) return;
            var cost = cell.vitality.max * 0.3;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var child = copyCell(cell);
            child.vitality.max *= randomFloat(0.9, 1.1);
            child.moveRange *= randomFloat(0.9, 1.1);
            child.searchRange *= randomFloat(0.9, 1.1);
            child.density *= randomFloat(0.9, 1.1);
            addCellToGame(child, game);
            var radius = cellRadius(cell);
            moveCell(child, movedPointWithRadian(cell, randomRadian(), radius * 2 + Math.random() * radius * 2), game);
            child.event = 'born';
            child.parent = cell;
        },
        shot: function(cell, game) {
            if (randomInt(0, 1000) != 0) return;
            var cost = cell.vitality.max / 1000;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var shot = copyCell(cell);
            addCellToGame(shot, game);
            shot.vitality.max *= 0.2;
            shot.vitality.current = shot.vitality.max * 0.1;
            shot.movingMethod.source = movingMethod.bound;
            shot.movingMethod.instance = movingMethod.bound();
            shot.moveRange = 2 + shot.moveRange / 2;
            shot.specialActions = [];
            shot.event = 'born';
            shot.parent = cell;
        },
        homingShot: function(cell, game) {
            if (randomInt(0, 1000) != 0) return;
            var cost = cell.vitality.max / 500;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var shot = copyCell(cell);
            addCellToGame(shot, game);
            shot.vitality.max *= 0.2;
            shot.vitality.current = shot.vitality.max / 4;
            var moving = function() {return movingMethod.tail(isEatingTarget, movingMethod.bound())};
            shot.movingMethod.source = moving;
            shot.movingMethod.instance = moving();
            shot.moveRange = 2 + shot.moveRange / 2;
            shot.searchRange *= 2;
            shot.specialActions = [];
            shot.event = 'born';
            shot.parent = cell;
        },
        makeMoon: function(cell, game) {
            if (randomInt(0, 1000) != 0) return;
            var cost = cell.vitality.max / 10;
            if (cell.vitality.current < cost) return;
            cell.vitality.current -= cost;
            var moon = copyCell(cell);
            addCellToGame(moon, game);
            moon.vitality.max *= 0.3;
            moon.vitality.current = moon.vitality.max;
            var radianIncrease = randomFloat(0.01, 0.5) * (randomBool() ? 1 : -1);
            var radius = cellRadius(cell);
            var distance = cellRadius(moon) + Math.random() * radius * 2;
            var moving = function() {return movingMethod.moon(function(moon, target) {return target == cell}, radianIncrease, distance, function (cell, game) {
                cell.vitality.current = 0;
                return 0;
            })};
            moveCell(moon, movedPointWithRadian(cell, randomRadian(), radius + distance), game);
            moon.movingMethod.source = moving;
            moon.movingMethod.instance = moving();
            moon.moveRange = (moon.moveRange + 0.5) * 2;
            moon.searchRange = game.field.width > game.field.height ? game.field.width : game.field.height;
            moon.specialActions = [];
            moon.event = 'born';
            moon.parent = cell;
        },
        split: function(cell, game) {
            if (randomInt(0, 500) != 0) return;
            if (cell.vitality.max < 10000) {
                return;
            }
            cell.vitality.current /= 2;
            cell.vitality.max /= 2;
            var newCell = copyCell(cell);
            addCellToGame(newCell, game);
            newCell.event = 'born';
            var distance = cellWeight(cell) / 2;
            moveCell(newCell, movedPointWithRadian(newCell, randomRadian(), distance), game);
        }
    };
    var cellMovingFrame = function(cell, game) {
        var movedDistance = cell.movingMethod.instance(cell, game);
        cell.lastMovedDistance = movedDistance;
        cell.vitality.current -= movedDistance * cellWeight(cell) / 5 + cellWeight(cell) / 10;
    };
    var applyHitting = function(cell, target) {
        var damage = (1 + cell.density) * ((cell.lastMovedDistance == undefined ? 0 : cell.lastMovedDistance) + 1) * 100;
        if (isEatingTarget(cell, target)) {
            damage -= damage * target.density / 10;
            target.vitality.current -= damage;
            target.event = 'damaged';
        }
        knockedPositionBase = target.knockedPosition == undefined ? target : target.knockedPosition;
        target.knockedPosition = movedPointWithRadian(knockedPositionBase, radianFromPoints(cell, knockedPositionBase), damage / 100);
    };
    var cellsHittingFrame = function(game) {
        var hittings = hittingCells(game);
        for (var i = 0, l = hittings.length; i < l; ++i) {
            var cell1 = hittings[i].cell1;
            var cell2 = hittings[i].cell2;
            applyHitting(cell1, cell2);
            applyHitting(cell2, cell1);
        }
    };
    var cellDied = function(cell, game) {
        var healRange = cellRadius(cell) * 3;
        var healTargets = cellsInRange(cell, healRange, game);
        var total = 0;
        for (var i = 0, l = healTargets.length; i < l; ++i) {
            if (!isEatingTarget(healTargets[i].cell, cell)) continue;
            total += healRange - healTargets[i].distance;
        }
        var restVitality = cell.vitality.max;
        for (var i = 0, l = healTargets.length; i < l; ++i) {
            if (!isEatingTarget(healTargets[i].cell, cell)) continue;
            var target = healTargets[i];
            var targetCell = target.cell;
            var rate = healRange - target.distance;
            var healVitality = restVitality * rate / total;
            total -= rate;
            if (healVitality > targetCell.vitality.max - targetCell.vitality.current) healVitality = targetCell.vitality.max - targetCell.vitality.current;
            targetCell.vitality.current += healVitality;
            restVitality -= healVitality;
            targetCell.event = 'healed';
        }
    };
    var cellsFrame = function(game) {
        for (var i = game.cells.length - 1; i >= 0; --i) {
            if (game.cells[i].vitality.current <= 0) {
                removeCellFromGame(game.cells[i], game);
            }
        }
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            cell.event = undefined;
            cellMovingFrame(cell, game);
        }
        cellsHittingFrame(game);
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            if (cell.vitality.current <= 0) cellDied(cell, game);
        }
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            for (var actionIndex = 0, actionCount = cell.specialActions.length; actionIndex < actionCount; ++actionIndex) {
                cell.specialActions[actionIndex](cell, game);
            }
        }
        for (var i = 0, l = game.cells.length; i < l; ++i) {
            var cell = game.cells[i];
            if (cell.knockedPosition != undefined) {
                moveCell(cell, cell.knockedPosition, game);
                cell.knockedPosition = undefined;
            }
        }
    };
    var makeRandomCell = function(field) {
        var initialPoint = randomPointOnField(field);
        var vitality = 10000 + randomInt(1, 10) * randomInt(1, 100) * randomInt(1, 50);
        var basicTargetFunctionGroups = [
//            [isEatingTarget, function(cell, other) {return !isEatingTarget(cell, other)}],
            [ // faster than me or not or unmoved
//                function(cell, other) {
//                    return other.lastMovedDistance != undefined && (cell.lastMovedDistance == undefined || cell.lastMovedDistance < other.lastMovedDistance);
//                },
                function(cell, other) {
                    return cell.lastMovedDistance != undefined && (other.lastMovedDistance == undefined || cell.lastMovedDistance >= other.lastMovedDistance);
                },
                function(cell, other) {
                    return cell.lastMovedDistance != undefined || cell.lastMovedDistance == 0;
                }
            ],
            [ // larger than me or not
                function(cell, other) {
                    return cellRadius(cell) < cellRadius(other);
                },
                function(cell, other) {
                    return cellRadius(cell) >= cellRadius(other);
                }
            ]
        ];
        var makeRandomTargetFunction = function() {
            var groups = filtered(randomBool, basicTargetFunctionGroups);
            var fns = [isEatingTarget];
            var functionCount = groups.length;
            for (var i = 0; i < functionCount; ++i) fns.push(randomFetch(groups[i]));
            return function(cell, other) {
                for (var i = 0; i < functionCount; ++i) {
                    if (!fns[i](cell, other)) return false;
                }
                return true;
            };
        };
        var basicMovingMethods = [
            movingMethod.immovable,
            movingMethod.randomDestination,
            movingMethod.furafura,
            movingMethod.bound,
            movingMethod.circle,
            movingMethod.chorochoro
        ];
        var makeRandomMovingMethod = function() {
            var basic = randomFetch(basicMovingMethods);
            return randomFetch([
//                function() {
//                    return movingMethod.moon(makeRandomTargetFunction(), Math.random() / 2, Math.random() * 10, basic());
//                },
                function() {
                    return movingMethod.tail(makeRandomTargetFunction(), basic());
//                },
//                function() {
//                    return movingMethod.escape(makeRandomTargetFunction(), basic());
                }]);
        };
        var moving = makeRandomMovingMethod();
//        var actions = filtered(randomBool, [specialActions.multiply, specialActions.shot, specialActions.homingShot, specialActions.makeMoon, specialActions.split]);
        var actions = filtered(randomBool, [specialActions.multiply, specialActions.makeMoon, specialActions.split]);
        var rgbRate = {red: Math.random(), green: Math.random(), blue: Math.random()};
        if (rgbRate.red == 0 && rgbRate.green == 0 && rgbRate.blue == 0) rgbRate = {red: 1, green: 1, blue: 1};
        return {x: initialPoint.x,
                y: initialPoint.y,
                vitality: {max: vitality, current: vitality},
                density: randomFloat(0.1, 1),
                movingMethod: {source: moving, instance: moving()},
                specialActions: actions,
                moveRange: 0.01 + randomFloat(0, 2) * randomFloat(0, 2) + Math.random(),
                searchRange: randomInt(0, 300),
                rgbRate: rgbRate};
    };
    var gameFrame = function(game) {
        cellsFrame(game);
        game.frameCount++;
        if (randomInt(0, game.cells.length * 2) == 0) {
            var newCell = makeRandomCell(game.field);
            newCell.event = 'born';
            addCellToGame(newCell, game);
        }
    };
    var makeSpacialIndex = function(field, split) {
        var grids = [];
        for (var x = 0; x < split; ++x) {
            grids[x] = [];
            for (var y = 0; y < split; ++y) {
                grids[x][y] = [];
            }
        }
        return {
            split: split,
            grids: grids
        };
    };
    var makeGame = function(field) {
        var game = {
            field: field,
            cells: [],
            nextCellID: 1,
            cellsSpacialIndex: makeSpacialIndex(field, 6),
            frameCount: 0
        };
        Lifegame.game = game;
        var i;
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            addCellToGame({x: initialPoint.x,
                           y: initialPoint.y,
                           vitality: {max: 8000, current: 8000},
                           density: 0.5,
                           movingMethod: {
                               source: movingMethod.circle,
                               instance: movingMethod.circle()
                           },
                           specialActions: [specialActions.makeChild],
                           moveRange: 2,
                           searchRange: 40,
                           rgbRate: {red: 0, green: 0, blue: 1}},
                         game);
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            var tailMovingCell = function() {
                return movingMethod.tail(function(cell) {
                    return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                }, movingMethod.randomDestination());
            };
            addCellToGame({x: initialPoint.x,
                           y: initialPoint.y,
                           vitality: {max: 80000, current: 80000},
                           density: 0.99,
                           movingMethod: {
                               source: tailMovingCell,
                                 instance: tailMovingCell()
                           },
                           specialActions: [],
                           moveRange: 1,
                           searchRange: 100,
                           rgbRate: {red: 1, green: 0.5, blue: 0.3}},
                         game);
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            addCellToGame({x: initialPoint.x,
                           y: initialPoint.y,
                           vitality: {max: 4000, current: 4000},
                           density: 0.1,
                           movingMethod: {
                               source: movingMethod.bound,
                               instance: movingMethod.bound()
                           },
                           specialActions: [],
                           moveRange: 3,
                           searchRange: 20,
                           rgbRate: {red: 0.5, green: 0.5, blue: 1}},
                         game);
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            addCellToGame({x: initialPoint.x,
                           y: initialPoint.y,
                           vitality: {max: 3500, current: 3500},
                           density: 0.99,
                           movingMethod: {
                               source: movingMethod.chorochoro,
                               instance: movingMethod.chorochoro()
                           },
                           specialActions: [],
                           moveRange: 0.5,
                           searchRange: 60,
                           rgbRate: {red: 1, green: 1, blue: 0}},
                         game);
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            addCellToGame({x: initialPoint.x,
                           y: initialPoint.y,
                           vitality: {max: 3000, current: 3000},
                           density: 0.33,
                           movingMethod: {
                               source: movingMethod.immovable,
                               instance: movingMethod.immovable()
                           },
                           specialActions: [],
                           moveRange: 0,
                           searchRange: 200,
                           rgbRate: {red: 0, green: 1, blue: 0.3}},
                         game);
        }
        for (i = 0; i < 0; i++) {
            var initialPoint = randomPointOnField(game.field);
            var tailMovingCell = function() {
                return movingMethod.tail(function(cell) {
                    return cell.lastMovedDistance != undefined && cell.lastMovedDistance > 1.5;
                }, movingMethod.chorochoro());
            };
            addCellToGame({x: initialPoint.x,
                           y: initialPoint.y,
                           vitality: {max: 5000, current: 5000},
                           density: 0.4,
                           movingMethod: {
                               source: tailMovingCell,
                               instance: tailMovingCell()
                           },
                           specialActions: [],
                           moveRange: 1.5,
                           searchRange: 160,
                           rgbRate: {red: 1, green: 0.5, blue: 1}},
                         game);
        }
        for (i = 0; i < 0; i++) {
            addCellToGame(makeRandomCell(game.field), game);
        }
        return game;
    };
    var resetCanvasSize = function(canvas, game) {
        canvas.style.width = game.field.width + 'px';
        canvas.style.height = game.field.height + 'px';
        canvas.width = game.field.width;
        canvas.height = game.field.height;
    };
    Lifegame.run = function(canvas, configuration) {
        var game = makeGame(configuration.field);
        Lifegame.game = game;
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
        var showCellInfo = false;
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
                context.fillStyle = 'rgba(255,255,255,1)';
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
                    var rated = Math.floor(180 * 3 * source / rgbRateTotal);
                    var adjusted = Math.floor((rated < 0 ? 0 : (rated > 255 ? 255 : rated))  + 64 - (128 * cell.density));
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
            var message = cell.message;
            if (showCellInfo) {
                message = (message != undefined ? message + ' ' : '') + cellType(cell) + ' ' + Math.ceil(cell.vitality.current / 10) + '/' + Math.ceil(cell.vitality.max / 10) + ' (' + (Math.floor(cell.density * 100)  / 100) + ')';
            }
            if (message != undefined && message != '') {
                context.fillStyle = 'rgba(255,255,255,1)';
                context.textBaseline = 'top';
                context.textAlign = 'center';
                context.fillText(message, cell.x, cell.y + radius + 1);
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
                Lifegame.game = game;
            },
            changeField: function(field) {
                game = makeGame(field);
                Lifegame.game = game;
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
            },
            toggleCellInfo: function() {
                showCellInfo = !showCellInfo;
            }
        };
    };
}());

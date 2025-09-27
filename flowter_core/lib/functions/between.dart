part of 'functions.dart';

bool isBetween(num value, num least, num biggest, [List<bool> inclusive= const [true,true]]) =>
    (inclusive[0]?value>=least:value>least) &&
        (inclusive[1]?value<=biggest:value<biggest);
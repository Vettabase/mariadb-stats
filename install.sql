/*
    This file is part of MariaDB Statistics Library.

    MariaDB Statistics Library is free software: you can redistribute it and/or modify it under the terms of the
    GNU Affero General Public License as published by the Free Software Foundation, version 3 of the License.

    MariaDB Statistics Library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License along with MariaDB Statistics Library.
    If not, see <https://www.gnu.org/licenses/>.
*/


CREATE OR REPLACE SCHEMA stats
    DEFAULT CHARACTER SET 'ascii'
    DEFAULT COLLATE 'ascii_bin'
    COMMENT 'MariaDB Statistics Library\nProject URL: https://github.com/Vettabase/mariadb-stats'
;
USE stats;


DELIMITER ||

    CREATE OR REPLACE AGGREGATE FUNCTION weighted_avg(item FLOAT, weight FLOAT)
        RETURNS FLOAT
        NOT DETERMINISTIC
        READS SQL DATA
    BEGIN
        DECLARE part FLOAT DEFAULT 0;
        DECLARE weight_sum FLOAT DEFAULT 0;
        DECLARE CONTINUE HANDLER FOR NOT FOUND
            RETURN part / weight_sum;
        lp_main: LOOP
            FETCH GROUP NEXT ROW;
            IF item IS NULL OR weight IS NULL THEN
                ITERATE lp_main;
            END IF;
            SET part := part + (item * weight);
            SET weight_sum := weight_sum + weight;
        END LOOP;
    END;

||
DELIMITER ;


DELIMITER ||

    CREATE OR REPLACE AGGREGATE FUNCTION geometric_mean(item FLOAT)
        RETURNS FLOAT
        NOT DETERMINISTIC
        READS SQL DATA
    BEGIN
        DECLARE part FLOAT DEFAULT 1;
        DECLARE weight_sum FLOAT DEFAULT 0;
        DECLARE CONTINUE HANDLER FOR NOT FOUND
            RETURN POW(part, 1 / weight_sum);
        lp_main: LOOP
            FETCH GROUP NEXT ROW;
            IF item IS NULL THEN
                ITERATE lp_main;
            ELSEIF item <= 0 THEN
                SIGNAL SQLSTATE '45000' SET
                    MYSQL_ERRNO=30001,
                    MESSAGE_TEXT='One of the observations is zero or less'
                ;
            END IF;
            SET part := part * item;
            SET weight_sum := weight_sum + 1;
        END LOOP;
    END;

||
DELIMITER ;


DELIMITER ||

    CREATE OR REPLACE AGGREGATE FUNCTION weighted_geometric_mean(
            item FLOAT,
            weight FLOAT
        )
        RETURNS FLOAT
        NOT DETERMINISTIC
        READS SQL DATA
    BEGIN
        DECLARE part FLOAT DEFAULT 1;
        DECLARE weight_sum FLOAT DEFAULT 0;
        DECLARE CONTINUE HANDLER FOR NOT FOUND
            RETURN POW(part, 1 / weight_sum);
        LOOP
            FETCH GROUP NEXT ROW;
            SET part := part * POW(item, weight);
            SET weight_sum := weight_sum + weight;
        END LOOP;
    END;

||
DELIMITER ;


DELIMITER ||

    CREATE OR REPLACE AGGREGATE FUNCTION harmonic_mean(item FLOAT)
        RETURNS FLOAT
        NOT DETERMINISTIC
        READS SQL DATA
    BEGIN
        DECLARE part FLOAT DEFAULT 0;
        DECLARE weight_sum FLOAT DEFAULT 0;
        DECLARE CONTINUE HANDLER FOR NOT FOUND
            RETURN weight_sum / part;
        lp_main: LOOP
            FETCH GROUP NEXT ROW;
            IF item IS NULL THEN
                ITERATE lp_main;
            ELSEIF item <= 0 THEN
                SIGNAL SQLSTATE '45000' SET
                    MYSQL_ERRNO=30001,
                    MESSAGE_TEXT='One of the observations is zero or less'
                ;
            END IF;
            SET part := part + 1 / item;
            SET weight_sum := weight_sum + 1;
        END LOOP;
    END;

||
DELIMITER ;


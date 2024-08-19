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


-- geometric_mean()

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT);
-- Expected Result: NULL
SELECT geometric_mean(i) FROM t;

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT);
INSERT INTO t VALUES (1.05), (1.03), (1.06), (1.02), (1.04);
-- Expected Result: 1.0399
SELECT geometric_mean(i) FROM t;

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT);
INSERT INTO t VALUES (1.05), (NULL), (1.03), (1.06), (1.02), (1.04);
-- Expected Result: NULL
SELECT geometric_mean(i) FROM t;

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT);
INSERT INTO t VALUES (1.05), (0), (1.03), (1.06), (1.02), (1.04);
-- Expected Error: ERROR 30001 (45000): One of the observation is zero or less
SELECT geometric_mean(i) FROM t;

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT);
INSERT INTO t VALUES (1.05), (-0.1), (1.03), (1.06), (1.02), (1.04);
-- Expected Error: ERROR 30001 (45000): One of the observation is zero or less
SELECT geometric_mean(i) FROM t;


-- weighted_geometric_mean()

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT, w FLOAT);
-- Expected Result: NULL
SELECT weighted_geometric_mean(i, w) FROM t;

CREATE OR REPLACE TEMPORARY TABLE t (i FLOAT, w FLOAT);
INSERT INTO t VALUES (1, 2), (2, 5), (3, 6), (4, 4), (5, 3);
-- Expected Result: 2.77748
SELECT weighted_geometric_mean(i, w) FROM t;

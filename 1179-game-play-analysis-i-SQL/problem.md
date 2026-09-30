# 1179. Game Play Analysis I

[https://leetcode.com/problems/game-play-analysis-i/](https://leetcode.com/problems/game-play-analysis-i/)

**Difficulty:** Easy

**Tags:**

- Database


---

Table: `Activity`

    +--------------+---------+
    | Column Name  | Type    |
    +--------------+---------+
    | player_id    | int     |
    | device_id    | int     |
    | event_date   | date    |
    | games_played | int     |
    +--------------+---------+
    (player_id, event_date) is the primary key (combination of columns with unique values) of this table.
    This table shows the activity of players of some games.
    Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.

Write a solution to find the **first login date** for each player.

Return the result table in **any order**.

The result format is in the following example.

**Example 1:**

    Input: 
    Activity table:
    +-----------+-----------+------------+--------------+
    | player_id | device_id | event_date | games_played |
    +-----------+-----------+------------+--------------+
    | 1         | 2         | 2016-03-01 | 5            |
    | 1         | 2         | 2016-05-02 | 6            |
    | 2         | 3         | 2017-06-25 | 1            |
    | 3         | 1         | 2016-03-02 | 0            |
    | 3         | 4         | 2018-07-03 | 5            |
    +-----------+-----------+------------+--------------+
    Output: 
    +-----------+-------------+
    | player_id | first_login |
    +-----------+-------------+
    | 1         | 2016-03-01  |
    | 2         | 2017-06-25  |
    | 3         | 2016-03-02  |
    +-----------+-------------+


---

### Environment:`MySQL 8.0`.

Note: For legacy reason, we didn\'t enable any SQL mode, including
`ONLY_FULL_GROUP_BY`, `STRICT_TRANS_TABLES`, `NO_ZERO_IN_DATE`,
`NO_ZERO_DATE`, `ERROR_FOR_DIVISION_BY_ZERO` and more.

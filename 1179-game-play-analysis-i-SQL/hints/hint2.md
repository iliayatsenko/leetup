Use GROUP BY to separate rows by player_id, then apply an aggregate function to find the minimum event_date within each group. This will give you one row per player with their earliest login date.

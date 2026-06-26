-- ================================================================
-- 🏏 CRICKET MASTER ANALYTICS PLATFORM
-- 10 Business SQL Queries
-- Covers: IPL | T20 WC | ODI WC | Test Cricket
-- SQL Concepts: SELECT, WHERE, GROUP BY, HAVING, ORDER BY,
--               CASE WHEN, JOINS, SUBQUERIES, WINDOW FUNCTIONS
-- ================================================================

-- ============================================================
-- Top 10 Run Scorers Across All Formats
-- ============================================================
SELECT player, COUNT(*) as innings, SUM(runs) as total_runs,
               ROUND(AVG(runs),2) as batting_avg, MAX(runs) as highest_score,
               ROUND(AVG(strike_rate),2) as avg_sr, SUM(sixes) as total_sixes,
               SUM(CASE WHEN runs>=50 THEN 1 ELSE 0 END) as fifties
        FROM batting WHERE runs IS NOT NULL
        GROUP BY player ORDER BY total_runs DESC LIMIT 10

-- ============================================================
-- Best IPL Teams by Win Share
-- ============================================================
SELECT winner as team, COUNT(*) as wins,
               ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM matches WHERE format='IPL'),1) as win_share_pct
        FROM matches WHERE format='IPL'
        GROUP BY winner ORDER BY wins DESC

-- ============================================================
-- India vs Australia Head to Head
-- ============================================================
SELECT format,
               SUM(CASE WHEN winner='India' THEN 1 ELSE 0 END) as india_wins,
               SUM(CASE WHEN winner='Australia' THEN 1 ELSE 0 END) as aus_wins,
               COUNT(*) as total_matches,
               ROUND(100.0*SUM(CASE WHEN winner='India' THEN 1 ELSE 0 END)/COUNT(*),1) as india_win_pct
        FROM matches
        WHERE (team1='India' AND team2='Australia') OR (team1='Australia' AND team2='India')
        GROUP BY format ORDER BY total_matches DESC

-- ============================================================
-- Venue Analysis — Toss and Match Stats
-- ============================================================
SELECT venue, COUNT(*) as total_matches,
               ROUND(100.0*SUM(toss_won_match)/COUNT(*),1) as toss_win_pct,
               SUM(CASE WHEN toss_decision='field' THEN 1 ELSE 0 END) as chose_field,
               SUM(CASE WHEN toss_decision='bat' THEN 1 ELSE 0 END) as chose_bat
        FROM matches WHERE venue IS NOT NULL
        GROUP BY venue ORDER BY total_matches DESC LIMIT 10

-- ============================================================
-- Toss Impact by Format
-- ============================================================
SELECT format, COUNT(*) as total_matches,
               SUM(toss_won_match) as toss_winners_won,
               ROUND(100.0*SUM(toss_won_match)/COUNT(*),1) as toss_advantage_pct,
               SUM(CASE WHEN toss_decision='field' AND toss_won_match=1 THEN 1 ELSE 0 END) as field_then_won,
               SUM(CASE WHEN toss_decision='bat' AND toss_won_match=1 THEN 1 ELSE 0 END) as bat_then_won
        FROM matches GROUP BY format ORDER BY toss_advantage_pct DESC

-- ============================================================
-- Player Consistency Rankings using RANK()
-- ============================================================
SELECT player, COUNT(*) as innings, ROUND(AVG(runs),2) as avg_runs,
               ROUND(AVG(strike_rate),2) as avg_sr,
               SUM(CASE WHEN runs>=50 THEN 1 ELSE 0 END) as fifties,
               SUM(CASE WHEN runs>=100 THEN 1 ELSE 0 END) as hundreds,
               RANK() OVER (ORDER BY AVG(runs) DESC) as consistency_rank
        FROM batting WHERE runs IS NOT NULL
        GROUP BY player HAVING innings >= 20 ORDER BY avg_runs DESC LIMIT 10

-- ============================================================
-- Best Bowlers by Economy Rate using DENSE_RANK()
-- ============================================================
SELECT bowler, COUNT(*) as matches, SUM(wickets) as total_wickets,
               ROUND(AVG(economy_rate),2) as avg_economy,
               ROUND(SUM(runs_conceded)*1.0/NULLIF(SUM(wickets),0),2) as bowling_avg,
               SUM(CASE WHEN wickets>=3 THEN 1 ELSE 0 END) as three_wicket_hauls,
               DENSE_RANK() OVER (ORDER BY AVG(economy_rate) ASC) as economy_rank
        FROM bowling GROUP BY bowler HAVING COUNT(*)>=15 ORDER BY avg_economy ASC LIMIT 10

-- ============================================================
-- Top Match Winning Performances by Tier
-- ============================================================
SELECT player, runs, balls_faced, strike_rate, fours, sixes, format, year,
               CASE
                   WHEN runs>=100 THEN 'Century 💯'
                   WHEN runs>=75  THEN 'Outstanding 🌟'
                   WHEN runs>=50  THEN 'Half Century ⭐'
                   ELSE 'Decent 👍'
               END as performance_tier,
               RANK() OVER (PARTITION BY format ORDER BY runs DESC) as format_rank
        FROM batting WHERE runs IS NOT NULL
        ORDER BY runs DESC LIMIT 15

-- ============================================================
-- Season-Wise Team Dominance
-- ============================================================
SELECT t.year, t.winner, t.wins FROM (
            SELECT year, winner, COUNT(*) as wins,
                   RANK() OVER (PARTITION BY year ORDER BY COUNT(*) DESC) as rk
            FROM matches GROUP BY year, winner
        ) t WHERE t.rk = 1 ORDER BY t.year DESC LIMIT 12

-- ============================================================
-- Player Segmentation: SR vs Average
-- ============================================================
SELECT player,
               ROUND(AVG(runs),1) as avg_runs,
               ROUND(AVG(strike_rate),1) as avg_sr,
               COUNT(*) as innings,
               CASE
                   WHEN AVG(runs)>=35 AND AVG(strike_rate)>=101 THEN 'Elite Allrounder 🔥'
                   WHEN AVG(runs)>=35 AND AVG(strike_rate)<101  THEN 'Consistent Anchor ⚓'
                   WHEN AVG(runs)<35  AND AVG(strike_rate)>=101 THEN 'Power Hitter 💪'
                   ELSE 'Developing Player 📈'
               END as player_type
        FROM batting WHERE runs IS NOT NULL
        GROUP BY player HAVING innings>=20 ORDER BY avg_runs DESC


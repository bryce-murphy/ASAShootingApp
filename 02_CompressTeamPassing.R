# Condense team passing data for web app

# Read dataset ####
passing <- readRDS("IgnoreList/AllPassingData.rds")

## balance predictions to actual by zone
passing <- passing %>%
  mutate(third = ifelse(x < 115/3, "Def",
                        ifelse(x < 115*2/3, "Mid", "Att")))

team.stats.offense <- passing %>%
  group_by(year, team, third) %>%
  summarize(N = n(),
            successes = sum(success),
            exp = sum(success.pred),
            Distance = sum(distance[success == 1]),
            Vert.Dist = sum((endX - x)[success == 1]))

team.stats.defense <- passing %>%
  group_by(year, team.1, third) %>%
  summarize(N = n(),
            successes = sum(success),
            exp = sum(success.pred),
            Distance = sum(distance[success == 1]),
            Vert.Dist = sum((endX - x)[success == 1]))

saveRDS(team.stats.offense, "IgnoreList/xPassingByTeamOffense.rds")
saveRDS(team.stats.defense, "IgnoreList/xPassingByTeamDefense.rds")

write.csv(team.stats.offense, "IgnoreList/xPassingByTeamOffense.csv", row.names = F)
write.csv(team.stats.defense, "IgnoreList/xPassingByTeamDefense.csv", row.names = F)
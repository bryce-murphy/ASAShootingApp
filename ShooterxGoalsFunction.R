# playerxgoals <- readRDS('xGoalsByPlayer.rds') %>%
#   mutate(date = as.Date(date, format = '%m/%d/%Y'))
# date1 = as.Date('2000-01-01')
# date2 = as.Date('9999-12-31')
# season = 2011:2017
# shotfilter = 0
# keyfilter = 0
# byteams = T
# FK = F
# PK = F

shooterxgoals.func <- function(playerxgoals = playerxgoals, 
                               date1 = as.Date('2000-01-01'), 
                               date2 = as.Date('9999-12-31'),
                               season = 2011:2017,
                               shotfilter = 0, 
                               keyfilter = 0,
                               byteams = F,
                               OtherShots = T,
                               FK = F,
                               PK = F){
  
  tempdat <- playerxgoals %>%
    filter(date >= date1 & date <= date2,
           Season %in% season,
           type %in% c('Other'[OtherShots], 'FK'[FK], 'PK'[PK]))
  
  if(byteams){
    aggdata <- tempdat %>%
      group_by(player, Team = team) %>%
      summarize(Shots = sum(shots),
                OnTarget = sum(ontarget),
                Dist = sum(shots*meddist, na.rm = T)/sum(shots),
                Unassisted = sum(unassisted)/Shots,
                Goals = sum(goals),
                xG = sum(xG),
                `G-xG` = sum(`G-xG`),
                KeyP = sum(keypasses),
                Dist.key = sum(keypasses*meddist.pass, na.rm = T)/sum(keypasses),
                Assts = sum(assists),
                xA = sum(xA),
                `A-xA` = sum(`A-xA`),
                `xG+xA` = sum(xG + xA)) %>%
      filter(Shots >= shotfilter,
             KeyP >= keyfilter)  
    
  }else{
    aggdata <- tempdat %>%
      group_by(player) %>%
      summarize(Team = paste0(na.omit(unique(team)), collapse = ', '),
                Shots = sum(shots),
                OnTarget = sum(ontarget),
                Dist = sum(shots*meddist, na.rm = T)/sum(shots),
                Unassisted = sum(unassisted)/Shots,
                Goals = sum(goals),
                xG = sum(xG),
                `G-xG` = sum(`G-xG`),
                KeyP = sum(keypasses),
                Dist.key = sum(keypasses*meddist.pass, na.rm = T)/sum(keypasses),
                Assts = sum(assists),
                xA = sum(xA),
                `A-xA` = sum(`A-xA`),
                `xG+xA` = sum(xG + xA)) %>%
      filter(Shots >= shotfilter,
             KeyP >= keyfilter)
  }
  
  return(aggdata %>% 
           filter(!is.na(player)) %>%
           rename(Player = player) %>%
           arrange(desc(`xG+xA`)))
  
}

# shooterxgoals.func(playerxgoals = readRDS('xGoalsByPlayer.rds') %>%
#                      mutate(date = as.Date(date, format = '%m/%d/%Y')),
#                    date1 = as.Date('2000-01-01'),
#                    date2 = as.Date('9999-12-31'),
#                    season = 2011:2017,
#                    shotfilter = 10,
#                    keyfilter = 10,
#                    byteams = T,
#                    FK = T,
#                    PK = T) -> x
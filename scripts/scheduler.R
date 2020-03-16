pacman::p_load(taskscheduleR)

myscript <- "C:/Users/Ido Bar/OneDrive - Griffith University/Teaching/6003ESC/covid19-dash/scripts/update_github.R"

## run script once within 62 seconds
taskscheduler_create(taskname = "testrun", rscript = myscript, 
                     schedule = "ONCE")

## Run every day at the same time on 09:10, starting from tomorrow on
## Mark: change the format of startdate to your locale if needed (e.g. US: %m/%d/%Y)
taskscheduler_create(taskname = "update_coviddash_website", rscript = myscript, 
                     schedule = "DAILY", starttime = "12:10")
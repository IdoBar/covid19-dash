pacman::p_load(git2r)

# setup the repository
repo_path <- "C:/Users/Ido Bar/OneDrive - Griffith University/Teaching/6003ESC/covid19-dash/"
setwd(repo_path)
repo <- repository(repo_path)
checkout(repo, "gh-pages", force = TRUE)
# compile the website
rmarkdown::render(file.path(repo_path, "index.Rmd"))
## Add file and commit
add(repo, ".")
commit(repo, glue::glue("Updated website on {format(Sys.time(), '%c')}"))

push(repo, "origin", "gh-pages")


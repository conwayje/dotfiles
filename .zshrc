alias rake="bundle exec rake"
alias be="bundle exec"
alias db_migrate="bin/rails db:migrate RAILS_ENV=development"
alias sql='mysql -u root -P "$MYSQL_PORT"'
alias refresh="git pull origin main && bundle install && rake db:migrate"
alias compare="git diff HEAD~1 HEAD~0"
alias list_aliases="cat ~/.zshrc | grep alias"
alias amend="git commit --amend -C HEAD"
alias fpush='git push --force origin "$(git symbolic-ref --short HEAD)"'
alias pushf='git push --force origin "$(git symbolic-ref --short HEAD)"'
alias pull="git pull"
alias gc-="git checkout -"
alias m="git checkout main"
alias gaa="git add --all"
alias gr="git reset --hard HEAD"
alias gpull='git pull origin "$(git symbolic-ref --short HEAD)"'
alias gpush='git push origin "$(git symbolic-ref --short HEAD)"'
alias gquick='gaa && amend && fpush'

function show_alias() {
  cat ~/.zshrc | grep "alias $1="
}

# Periodically Spin loses its session for bundler to install private gems. Running either of these fixes the problem.
alias bundler_fix='bundle config --global PKGS__SHOPIFY__IO "token:$(gsutil cat gs://dev-tokens/cloudsmith/shopify/gems/latest)"'
alias bundler_fix2='systemctl restart gcs-secrets.service && systemctl restart template-config.service'

# Core uses Rubocop for linting. This runs Rubocop only on your branch’s change delta, which is quite fast for local feedback.
alias rubocop_check='dev style --include-branch-commits'

# Core uses Sorbet for type checking. This runs Sorbet type checking only on your branch’s change delta, so it’s quite fast for local feedback.
alias sorbet_check='bin/srb typecheck'

# Runs Sorbet on a single library file (generally ActiveRecord) to regenerate its hidden RBI class.
# Run it as sorbet_one “Content::Entry”. Runs quite fast with manually-defined targets.
sorbet_one() {
  dev rbi dsl $1
}

# This runs Sorbet across the entire repo to regenerate RBI classes for library code fixtures. 
# Run it when you’re not sure what files you’ve touched that might need to be regenerated. Takes a loooong time.
alias sorbet_all='dev rbi dsl'

# This runs Packwerk across your local branch looking for component violations. It takes a while to run.
alias packwerk_check='dev packages check'

# Whenever any GraphQL schema changes, we need to compile the Ruby class architecture into a GraphQL SDL dump, ex:
# https://github.com/Shopify/shopify/blob/main/db/graphql/storefront_schema_unstable_public.graphql
# Run this command once to perform the action, and then commit the results. It takes a while to run.
alias graphql_dump='dev dump-graphql admin'

alias copme='rubocop_check'
alias lintme='rubocop_check'
alias typeme='sorbet_check'
alias packme='packwerk_check'
alias graphme='graphql_dump'
alias squashme='ruby git_helper.rb'

port_process() {
  lsof -n -i4TCP:$1 | grep LISTEN
}

kill_process() {
  port_process $1 | awk '{print $2}' | xargs kill -9
}

# Spin default setup
source /etc/zsh/zshrc.default.inc.zsh

function git_branch() {
  branch=$(git branch --show-current 2> /dev/null)
  if [[ $branch == "" ]]; then
    echo ' '
  else
    echo ' ('$branch') '
  fi
}

setopt prompt_subst
PROMPT='/%c%F{magenta}$(git_branch)%f$ '

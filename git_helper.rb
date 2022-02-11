commits = `git log --format="%an!<>!%h!<>!%s" -n 50`.split("\n").map{ |commit| commit.split("!<>!") }
author_name = "Jeff Conway"

count = 0
commits.each do |commit|
  if commit[0] == author_name
    count += 1
  else
    break
  end
end

puts "> The last #{count} commits belong to #{author_name}.
> Here are those commits plus the few prior to check:

"
commits.first(count + 4).each do |commit|
  puts "    #{commit.join(" | ")}"
end

puts "
> For interactive mode, you can use:

    git rebase -i HEAD~#{count}

> For quick mode, use:

    git reset --hard HEAD~#{count} && git merge --squash HEAD@{1} && git commit

> This program can also auto-commit using your first commit message and
> summarizing #{count} subsequent squashed commit(s).  That message would start:

    #{commits[count - 1][2]}

"

print "> Use this message and commit automatically? (Y/n): "
input = gets.chomp

if input == "Y"
  commit_message = "#{commits[count - 1][2]}"
  if count > 0
    commit_message += "\n\n"
    commits.first(count - 1).each do |commit|
      commit_message += "Includes ##{commit[1][0..6]} - #{commit[2][0..139]}\n"
    end
  end
  commit_message.chop!
end

puts "> The commit message would be:
###################################

#{commit_message}

###################################

"

print "> Continue? (Y/n): "
input2 = gets.chomp

if input2 == "Y"
  puts "> Squashing..."
  `git reset --hard HEAD~#{count}`
  `git merge --squash HEAD@{1}`
  `git commit -m \"#{commit_message}\"`

  puts "> Check git log to confirm success"
end

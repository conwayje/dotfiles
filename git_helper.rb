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

puts "> The last #{count} commits belong to #{author_name}."
puts "> Here are those commits plus the few prior to check: "
puts
commits.first(count + 4).each do |commit|
  puts "> #{commit.join(" | ")}"
end
puts
puts "> For interactive mode, you can use: "
puts
puts "git rebase -i HEAD~#{count}"
puts
puts "> For quick mode, use: "
puts
puts "git reset --hard HEAD~#{count} && git merge --squash HEAD@{1} && git commit"

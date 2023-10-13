namespace :fox_tail do
  # Get the root directory for the gem
  task :which do
    puts FoxTail.root.to_s
  end
end

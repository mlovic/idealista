require "bundler/gem_tasks"

task :local_install do
  system "gem build idealista.gemspec"
  system "gem install --local idealista-0.0.1.gem"
  puts   'gem reinstalled locally'
end


#! /usr/bin/ruby
=begin
  $Id$

                  Arachni v0.1-planning
  Copyright (c) 2010 Anastasios Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LINCENSE file for details)

=end

#
# Arachni driver
#
# @author: Zapotek <zapotek@segfault.gr>
# @version: 0.1-planning
#

require 'rubygems'
require 'anemone'
require 'getoptlong'
require 'lib/spider'
require 'ap'
require 'pp'

VERSION  = '0.1-planning'
REVISION = '$Rev$'
 
#
# Outputs Arachni banner.<br/>
# Displays version number, revision number, author details etc.
#
def banner

  puts 'Arachni v' + VERSION + ' [' + REVISION + '] initiated.
     Author: Anastasios "Zapotek" Laskos <zapotek@segfault.gr>
     Website: http://www.segfault.gr

'

end

#
# Outputs help/usage information.<br/>
# Displays supported options and parameters.
#
def usage
  puts <<USAGE
Usage:  arachni \[options\] url

Supported options:
  
  General ----------------------

  -h
  --help                      output this
  
  -r
  --resume                    resume suspended session
  
  -v                          be verbose
  
  --cookie-jar=<cookiejar>    specify cookiejar
  
  --user-agent=<user agent>   specify user agent
  
  
  Crawler -----------------------
  
  -e <regex>
  --exclude=<regex>           exclude urls matching regex
  
  -i <regex>
  --include=<regex>           include urls matching this regex only

  --obey-robots-txt           obey robots.txt file (default: false)
  
  --depth=<number>            depth limit (default: inf)
                                How deep Arachni should go into the site structure.
                                
  --link-depth=<number>       how many links to follow (default: inf)                              
  
  --redirect-limit=<number>   how many redirects to follow (default: inf)

  --threads=<number>          how many threads to instantiate (default: 3)
                                More threads does not necessarily mean more speed,
                                be careful when adjusting thread count.

  Auditor ------------------------                                
                                
  -g
  --audit-links               audit link variables (GET)
  
  -p
  --audit-forms               audit form variables
                                (Usually POST, can also be GET)
  
  -c
  --audit-cookies             audit cookies (COOKIE)

  
  Modules ------------------------
                                                                    
  -l
  --lsmod                     list available modules

    
  -m <modname,modname..>
  --mods=<modname,modname..>  comma separated list of modules to deploy
  

  Proxy --------------------------
  
  --proxy=<server:port>       specify proxy
  
  --proxy-type=<type>         specify proxy type
  

USAGE

end

banner

opts = GetoptLong.new(
[ '--help', '-h', GetoptLong::NO_ARGUMENT ],
[ '--resume', '-r', GetoptLong::NO_ARGUMENT ],
[ '--verbosity', '-v', GetoptLong::OPTIONAL_ARGUMENT ],
[ '--lsmod', '-l', GetoptLong::NO_ARGUMENT ],
[ '--audit-links', '-g', GetoptLong::NO_ARGUMENT ],
[ '--audit-forms', '-p', GetoptLong::NO_ARGUMENT ],
[ '--audit-cookies', '-c', GetoptLong::NO_ARGUMENT ],
[ '--obey-robots-txt', '-o', GetoptLong::NO_ARGUMENT ],
[ '--depth','-d', GetoptLong::REQUIRED_ARGUMENT ],
#[ '--delay','-k', GetoptLong::REQUIRED_ARGUMENT ],
[ '--redirect-limit','-q', GetoptLong::REQUIRED_ARGUMENT ],
[ '--threads','-t', GetoptLong::REQUIRED_ARGUMENT ],
[ '--link-depth','-u', GetoptLong::REQUIRED_ARGUMENT ],
[ '--mods','-m', GetoptLong::REQUIRED_ARGUMENT ],
[ '--site-auth','-a', GetoptLong::REQUIRED_ARGUMENT ],
[ '--proxy','-z', GetoptLong::REQUIRED_ARGUMENT ],
[ '--proxy-type','-x', GetoptLong::REQUIRED_ARGUMENT ],
[ '--cookie-jar','-j', GetoptLong::REQUIRED_ARGUMENT ],
[ '--user-agent','-b', GetoptLong::REQUIRED_ARGUMENT ],
[ '--exclude','-e', GetoptLong::REQUIRED_ARGUMENT ],
[ '--include','-i', GetoptLong::REQUIRED_ARGUMENT ]
)

runtime_args = {};

opts.each do |opt, arg|

  case opt

  when '--help'
    usage
    exit 0
    
  when '--resume'
    runtime_args[:resume] = true

  when '--verbosity'
    runtime_args[:arachni_verbose] = true

  when '--obey_robots_txt'
    runtime_args[:obey_robots_txt] = true

  when '--depth'
    runtime_args[:depth_limit] = arg.to_i
  
  when '--link-depth'
    runtime_args[:link_depth_limit] = arg.to_i
          
  when '--redirect-limit'
    runtime_args[:redirect_limit] = arg.to_i

#  when '--delay'
#    runtime_args[:delay] = arg.to_i
                        
  when '--lsmod'
    #

  when '--threads'
    runtime_args[:threads] = arg.to_i
          
  when '--audit-links'
    runtime_args[:audit_links] = true

  when '--audit-forms'
    runtime_args[:audit_forms] = true

  when '--audit-cookies'
    runtime_args[:audit_cookies] = true

  when '--mods'
    runtime_args[:mods] = arg

  when '--site-auth'
    runtime_args[:site_auth] = arg

  when '--proxy'
    runtime_args[:proxy] = arg

  when '--proxy-type'
    runtime_args[:proxy_type] = arg

  when '--cookie-jar'
    runtime_args[:cookie_jar] = arg

  when '--user-agent'
    runtime_args[:user_agent] = arg

  when '--exclude'
    runtime_args[:exclude] = Regexp.new( arg )
   
  when '--include'
    runtime_args[:include] = Regexp.new( arg )

  end
end

runtime_args[:url] = ARGV.shift

begin
  runtime_args[:url] = URI.parse( URI.encode( runtime_args[:url] ) )
rescue
  puts "Error: Invalid URL argument."
  puts "URL must be of type 'scheme://username:password@subdomain.domain.tld:port/path?query_string#anchor'"
  puts
  puts "Examples:"
  puts "    http://www.google.com"
  puts "    https://secure.wikimedia.org/wikipedia/en/wiki/Main_Page"
  puts "    http://zapotek:secret@www.myweb.com/index.php"
  puts
  exit 0
end

#ap runtime_args

if runtime_args[:url] == nil
  puts "Error: Missing url argument (try --help)"
  puts
  exit 0
end

puts 'Analysing site structure...'

spider = Spider.new( runtime_args )

#ap runtime_args
ap spider.site_structure
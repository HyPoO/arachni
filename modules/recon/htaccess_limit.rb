=begin
                  Arachni
  Copyright (c) 2010-2012 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

module Arachni
module Modules

#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1.2
#
class Htaccess < Arachni::Module::Base

    include Arachni::Module::Utilities

    def run
        return if @page.code != 401

        @http.post( @page.url ).on_complete {
            |res|
            __log_results( res ) if res.code == 200
        }
    end

    def self.info
        {
            :name           => '.htaccess LIMIT misconfiguration',
            :description    => %q{Checks for misconfiguration in LIMIT directives that blocks
                GET requests but allows POST.},
            :elements       => [ ],
            :author         => 'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>',
            :version        => '0.1.2',
            :references     => {},
            :targets        => { 'Generic' => 'all' },
            :issue   => {
                :name        => %q{Misconfiguration in LIMIT directive of .htaccess file.},
                :description => %q{The .htaccess file blocks GET requests but allows POST.},
                :tags        => [ 'htaccess', 'server', 'limit' ],
                :cwe         => '',
                :severity    => Issue::Severity::HIGH,
                :cvssv2       => '',
                :remedy_guidance    => '',
                :remedy_code => '',
            }
        }
    end

    def __log_results( res )

        log_issue(
            :url          => res.effective_url,
            :method       => res.request.method.to_s.upcase,
            :elem         => Issue::Element::SERVER,
            :response     => res.body,
            :headers      => {
                :request    => res.request.headers,
                :response   => res.headers,
            }
        )

        print_ok( 'Request was accepted: ' + res.effective_url )
    end

end
end
end

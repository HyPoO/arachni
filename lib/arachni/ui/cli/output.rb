=begin
                  Arachni
  Copyright (c) 2010-2012 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

module Arachni

module UI

#
# CLI Output module
#
# Provides a command line output interface to the framework.<br/>
# All UIs should provide an Arachni::UI::Output module with these methods.
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1.1
#
module Output

    # verbosity flag
    #
    # if it's on verbose messages will be enabled
    @@verbose = false

    # debug flag
    #
    # if it's on debugging messages will be enabled
    @@debug   = false

    # only_positives flag
    #
    # if it's on status messages will be disabled
    @@only_positives  = false

    @@mute  = false

    @@opened = false

    # Prints an error message
    #
    # It ignores all flags, error messages will be output under all
    # circumstances.
    #
    # @param    [String]    error string
    # @return    [void]
    #
    def print_error( str = '' )
        print_color( '[-]', 31, str, $stderr, true )
        File.open( 'error.log', 'a' ){
            |f|
            if !@@opened
                f.puts
                f.puts "#{Time.now} " + ( "-" * 80 )

                h = {}
                ENV.each { |k, v| h[k] = v }
                f.puts 'ENV:'
                f.puts h.to_yaml

                f.puts "-" * 80

                f.puts 'OPTIONS:'
                f.puts Arachni::Options.instance.to_yaml

                f.puts "-" * 80
            end
            print_color( "[#{Time.now}]", 31, str, f, true )
        }

        @@opened = true
    end

    #
    # Same as print_error but the message won't be printed to stderr.
    #
    # Used mainly to draw attention.
    #
    # @param    [String]    error string
    #
    def print_bad( str = '', unmute = false )
        return if muted? && !unmute
        print_color( '[-]', 31, str, $stdout, unmute )
    end

    # Prints a status message
    #
    # Obeys {@@only_positives}
    #
    # @see #only_positives?
    # @see #only_positives!
    #
    # @param    [String]    status string
    # @return    [void]
    #
    def print_status( str = '', unmute = false )
        if @@only_positives then return end
        print_color( '[*]', 34, str, $stdout, unmute )
    end

    # Prints an info message
    #
    # Obeys {@@only_positives}
    #
    # @see #only_positives?
    # @see #only_positives!
    #
    # @param    [String]    info string
    # @return    [void]
    #
    def print_info( str = '', unmute = false )
        if @@only_positives then return end
        print_color( '[~]', 30, str, $stdout, unmute )
    end

    # Prints a good message, something that went very very right,
    # like the discovery of a vulnerability
    #
    # Disregards all flags.
    #
    # @param    [String]    ok string
    # @return    [void]
    #
    def print_ok( str = '', unmute = false )
        print_color( '[+]', 32, str, $stdout, unmute )
    end

    # Prints a debugging message
    #
    # Obeys {@@debug}
    #
    # @see #debug?
    # @see #debug!
    #
    # @param    [String]    debugging string
    # @return    [void]
    #
    def print_debug( str = '', unmute = false )
        if !@@debug then return end
        print_color( '[!]', 36, str, $stderr, unmute )
    end

    # Pretty prints an object, used for debugging,
    # needs some improvement but it'll do for now
    #
    # Obeys {@@debug}
    #
    # @see #debug?
    # @see #debug!
    #
    # @param    [Object]
    # @return    [void]
    #
    def print_debug_pp( obj = nil )
        if !@@debug then return end
        pp obj
    end

    # Prints the backtrace of an exception
    #
    # Obeys {@@debug}
    #
    # @see #debug?
    # @see #debug!
    #
    # @param    [Exception]
    # @return    [void]
    #
    def print_debug_backtrace( e )
        if !@@debug then return end
        e.backtrace.each{ |line| print_debug( line ) }
    end

    def print_error_backtrace( e )
        e.backtrace.each{ |line| print_error( line ) }
    end


    # Prints a verbose message
    #
    # Obeys {@@verbose}
    #
    # @see #verbose?
    # @see #verbose!
    #
    # @param    [String]    verbose string
    # @return    [void]
    #
    def print_verbose( str = '', unmute = false )
        if !@@verbose then return end
        print_color( '[v]', 37, str, $stdout, unmute )
    end

    # Prints a line of message
    #
    # Obeys {@@only_positives}
    #
    # @see #only_positives?
    # @see #only_positives!
    #
    # @param    [String]    string
    # @return    [void]
    #
    def print_line( str = '', unmute = false )
        if @@only_positives then return end
        return if muted? && !unmute
        puts str
    end

    # Sets the {@@verbose} flag to true
    #
    # @see #verbose?
    #
    # @return    [void]
    #
    def verbose!
        @@verbose = true
    end

    # Returns the {@@verbose} flag
    #
    # @see #verbose!
    #
    # @return    [Bool]    @@verbose
    #
    def verbose?
        @@verbose
    end

    # Sets the {@@debug} flag to true
    #
    # @see #debug?
    #
    # @return    [void]
    #
    def debug!
        @@debug = true
    end

    # Returns the {@@debug} flag
    #
    # @see #debug!
    #
    # @return    [Bool]    @@debug
    #
    def debug?
        @@debug
    end

    # Sets the {@@only_positives} flag to true
    #
    # @see #only_positives?
    #
    # @return    [void]
    #
    def only_positives!
        @@only_positives = true
    end

    # Returns the {@@only_positives} flag
    #
    # @see #only_positives!
    #
    # @return    [Bool]    @@only_positives
    #
    def only_positives?
        @@only_positives
    end

    def mute!
        @@mute = true
    end

    def unmute!
        @@mute = false
    end


    def muted?
        @@mute
    end

    private

    # Prints a message prefixed with a colored sign.
    #
    # Disregards all flags.
    #
    # @param    [String]    sign
    # @param    [Integer]   shell color number
    # @param    [String]    the string to output
    #
    # @return    [void]
    #
    def print_color( sign, color, string, out = $stdout, unmute = false )
        return if muted? && !unmute

        if out.tty?
            out.print "\033[1;#{color.to_s}m #{sign}\033[1;00m #{string}\n";
        else
            out.print "#{sign} #{string}\n";
        end
    end

    extend self

end

end
end

# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the (RottenPotatoes )?home\s?page$/ then '/movies'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page( for "([^"].*)")?$/
        title = $3
        path_components = $1.split(/\s+/)
        # are we using 'page for "MOVIE_NAME"' format or not?
        if !title.nil?
          movie = Movie.find_by(title: title)
          # details is the same as show page, which is routed with movie_path
          if path_components == ["details"] then path_components = [] end
          self.send(path_components.push('movie_path').join('_').to_sym, movie)
        else
          self.send(path_components.push('path').join('_').to_sym)
        end
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

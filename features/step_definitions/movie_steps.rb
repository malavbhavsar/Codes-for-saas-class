# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
     movies_from_page = []
     page.all("table#movies tbody#movielist tr td[1]").each do |x|
       movies_from_page<<x.text
     end
     i1 = movies_from_page.rindex(e1)
     i2 = movies_from_page.rindex(e2)
     i1.should_not be_nil
     i2.should_not be_nil
     i1.should be < i2
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    if uncheck == "un" then
      step 'uncheck '+'"'+'ratings_'+rating+'"'
    else
      step 'check '+'"'+'ratings_'+rating+'"'
    end
  end
end

Then /movies with these ratings are (in)?visible: (.*)/ do |invisible, rating_list|
#  ratings_from_page = page.all("table#movies tbody#movielist tr td[2]"
ratings_from_page = []
page.all("table#movies tbody#movielist tr td[2]").each do |x|
  ratings_from_page<<x.text
end
  if invisible == "in"
    (ratings_from_page & rating_list.split(',')).should be_empty
  else
    rating_list.split(',').each do |rating|
      ratings_from_page.should include(rating)
    end
  end
end

Then /I should see (all|none) of the movies/ do |allnone|
  if allnone == "all" then
    page.all("table#movies tbody#movielist tr td[2]").length().should be == 10
  else
    page.all("table#movies tbody#movielist tr td[2]").length().should be == 0
  end
end

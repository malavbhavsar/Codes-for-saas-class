require 'spec_helper'

describe MoviesController do
  describe 'find movie with same director' do
    before :each do
      @m = double('movie')
      @m2 = double('movie')
      @m.stub(:title=>'Star Wars',:director=>'George Lucas')
      @m2.stub(:title=>'THX-1138',:director=>'George Lucas')
    end
    it 'should call the model method that performs THE search' do
      Movie.should_receive(:find_movie_with_same_director).with(@m.director).and_return([@m,@m2])
      post :find_movie_with_same_director,{:mov => @m.director}
    end
    describe 'after valid search' do
      before :each do
        Movie.stub(:find_movie_with_same_director).and_return([@m,@m2])
        post :find_movie_with_same_director,{:mov => @m.director}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('find_movie_with_same_director')
      end
      it 'should make the search results available to that template' do
        assigns(:movies).should == [@m,@m2]
      end
    end
  end
end

require 'spec_helper'

describe MoviesController do
  describe 'find movie with same director' do
    before :each do
      @m = FactoryGirl.build(:movie, :id=>1, :title => 'Milk', :rating => 'R', :director=> 'abc')
      @m2 = FactoryGirl.build(:movie, :id=>2, :title => 'Milk2', :rating => 'R', :director=> 'abc')
      @m3 = FactoryGirl.build(:movie, :id=>3, :title => 'Milk3', :rating => 'R', :director=> '' )
      @fake_results = [@m, @m2]
    end
    it 'should call the model method that performs THE search' do
      Movie.should_receive(:find_movie_with_same_director).with(@m.id.to_s).and_return(@fake_results)
      post :find_movie_with_same_director,{:mov => @m.id}
    end
    describe 'after valid search' do
      before :each do
        Movie.stub(:find_movie_with_same_director).and_return(@fake_results)
        post :find_movie_with_same_director,{:mov => @m.id}
      end
      it 'should select the index template for rendering' do
        response.should render_template('index')
      end
      it 'should make the search results available to that template' do
        assigns(:movies).should == @fake_results
      end
      it 'should give appropriate values to the variables used in view' do
        assigns(:all_ratings).should == Movie.all_ratings
        assigns(:selected_ratings) == Movie.all_ratings
      end
    end
    describe 'after search we get nothing' do
      before :each do
        Movie.stub(:find_movie_with_same_director).and_return([])
        Movie.stub(:find_by_id).and_return(@m3)
        post :find_movie_with_same_director,{:mov => @m3.id}
      end
      it 'should redirect to homepage' do
        response.should redirect_to(movies_path)
      end
    end
  end
end

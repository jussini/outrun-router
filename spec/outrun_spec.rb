require 'spec_helper'

describe OutrunRouter, "#get_max_likes" do
  it "returns 0 for 0 likes route" do
    likes = ["0"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(0)
  end
  
  it "returns 1 for 1 likes route 1" do
    likes = ["1"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(1)
  end
  
  it "returns 1 for 1 likes route 2" do
    likes = ["0", "1 1"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(1)
  end
  
  it "returns 2 for 2 depth route with only 1 likes" do
    likes = ["1", "1 1"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(2)
  end
  
  it "returns 2 for 2 depth route with left biased 1 likes" do
    likes = ["1", "1 0"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(2)
  end
  
  it "returns 2 for 2 depth route with right biased 1 likes" do
    likes = ["1", "0 1"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(2)
  end
  
  #    2
  #   1 4
  # 8  3  3
  it "can avoid non-greedy path" do
    likes = ["2", "1 4", "8 3 3"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(11)
  end
  
  it "passes the problem example" do
    likes = ["22", "14 81", "81 46 34", "83 59 94 9"]
    router = OutrunRouter.new likes
    router.get_max_likes.should eq(243)
  end
  
end
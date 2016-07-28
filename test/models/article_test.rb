require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
#################################
# test article creations and save
#################################
  test "insert and read proper article" do
    article = Article.new
    title = "This is a test"
    text = "this is the body of the text"
    article.title = title
    article.text = text
    assert article.save
    article.save
    article_read = Article.where(title: title, text: text).first
    assert(article_read.title, title)
    assert(article_read.text, text)
  end

  test "should not save article without title" do
    article = Article.new
    assert_not article.save
  end

  test "should not save article with title shorter than 5" do
    article = Article.new
    article.title = 'aaaa'
    assert_not article.save
  end

  test "should save article with tilte of 5 letters" do
    article = Article.new
    article.title = 'aaaaa'
    assert article.save
  end
######################
# test article updates
######################
  test "should not update an article because title is empty" do
    article = articles(:one)
    article.title = ""
    assert_not article.save
  end

  test "should not update an article because title is too short" do
    article = articles(:one)
    article.title = "aaaa"
    assert_not article.save
  end

  test "should update an article and readback correct update" do
    article = articles(:one)
    title = "This is a test update"
    text = "this is the updated body of the text"
    article.title = title
    article.text = text
    assert article.save
    article.save
    article_read = Article.where(title: title, text: text).first
    assert(article_read.title, title)
    assert(article_read.text, text)
  end
#####################
# test article delete
#####################
  test "should delete article" do
    article = articles(:delete)
    assert article.destroy
  end

end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
include Faker

# start with empty db?
# Article.destroy_all

50.times do
  article = Article.create(
              title: Company.bs,
              text:  Lorem.paragraphs(rand(1..5)).join('<br/><br/>')
                          )
  #puts article.inspect

  # create up to 5 random comments per article
  rand(5).times do
    article.comments.create(
              commenter:  Name.name,
              body:       Lorem.paragraphs(rand(1..3)).join('<br/><br/>')
                        )
    #puts article.comments.inspect
  end
end

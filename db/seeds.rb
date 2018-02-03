# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'active_record/fixtures'

ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('test', 'fixtures'), 'users')
ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('test', 'fixtures'), 'projects')
ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('test', 'fixtures'), 'issues')
ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('test', 'fixtures'), 'issue_transactions')

# This file should contain all the record creation needed to seed the database
#   with its default values.
# The data can then be loaded with the rails db:seed command
#   (or created alongside the database with db:setup).
#
# Examples:
# rubocop:disable Style/LineLength
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# rubocop:enable Style/LineLength
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'suguru', login_id: 'suguru_omura', login_pass: '55mobage')
User.create(name: 'hoge1', login_id: 'hoge1', login_pass: 'fuga')
User.create(name: 'hoge2', login_id: 'hoge2', login_pass: 'fuga')
User.create(name: 'hoge3', login_id: 'hoge3', login_pass: 'fuga')
User.create(name: 'hoge4', login_id: 'hoge4', login_pass: 'fuga')

FriendRequest.create(user_id: 1, friend_user_id: 2, status: 'accepted')
FriendRequest.create(user_id: 1, friend_user_id: 3, status: 'accepted')
FriendRequest.create(user_id: 1, friend_user_id: 4, status: 'accepted')
FriendRequest.create(user_id: 1, friend_user_id: 5, status: 'accepted')

Friend.create(user_id: 1, friend_user_id: 2)
Friend.create(user_id: 1, friend_user_id: 3)
Friend.create(user_id: 1, friend_user_id: 4)
Friend.create(user_id: 1, friend_user_id: 5)
Friend.create(user_id: 2, friend_user_id: 1)
Friend.create(user_id: 3, friend_user_id: 1)
Friend.create(user_id: 4, friend_user_id: 1)
Friend.create(user_id: 5, friend_user_id: 1)

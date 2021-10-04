Rails.application.routes.draw do
  get '/manager/tasks', to: 'manager/tasks#list'
  post '/manager/tasks', to: 'manager/tasks#create'
  patch '/manager/tasks/:id', to: 'manager/tasks#update'
  delete '/manager/tasks/:id', to: 'manager/tasks#delete'
  post '/manager/tasks/assign', to: 'manager/tasks#assign'
  post '/manager/tasks/merge', to: 'manager/tasks#merge'

  get '/worker/tasks', to: 'worker/tasks#list'
  patch '/worker/tasks/:id', to: 'worker/tasks#update'
end

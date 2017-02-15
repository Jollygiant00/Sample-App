Rails.application.routes.draw do
  get 'dynamic_pages/browse'

  get 'dynamic_pages/item'

  get 'static_pages/home'

  get 'static_pages/help'
  
  get 'static_pages/about'
  
  get 'static_pages/contact'

  root 'static_pages#home'
end

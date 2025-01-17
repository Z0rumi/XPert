# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "institution_association", to: "experts/institution_association.js"
pin "cv_validation", to: "experts/cv_validation.js"
pin "document_validation", to: "projects/document_validation.js"
pin_all_from "app/javascript/controllers", under: "controllers"

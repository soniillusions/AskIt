// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap"

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"

import 'bootstrap/js/dist/dropdown'
import 'bootstrap/js/dist/collapse'
import './scripts/select2'

Rails.start()
Turbolinks.start()



project = "demo-webserver"

app "demo-webserver" {
  labels = {
    "service" = "demo-webserver",
    "env"     = "demo"
  }

  build {
    use "docker" {
      dockerfile = "${path.app}/Dockerfile"
    }

    registry {
      use "docker" {
        image = "demo-webserver"
        tag   = gitrefpretty()
        local = true
      }
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/demo-webserver.nomad.hcl", {
        image = artifact.image
      })
    }
  }
}

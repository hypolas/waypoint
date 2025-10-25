job "demo-webserver" {
  # Datacenter où déployer
  datacenters = ["dc1"]
  
  # Type de job
  type = "service"
  
  # Groupe de tâches
  group "web" {
    # Nombre d'instances
    count = 1
    
    # Configuration réseau
    network {
      port "http" {
        static = 8080
        to     = 80
      }
    }
    
    # Tâche principale
    task "nginx" {
      driver = "docker"
      
      config {
        image = "nginx:alpine"
        ports = ["http"]
        
        # Monter un volume pour le contenu personnalisé
        volumes = [
          "local:/usr/share/nginx/html"
        ]
      }
      
      # Créer une page HTML personnalisée
      template {
        data = <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demo Nomad Webserver</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        .info {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .info-item {
            margin: 10px 0;
            font-size: 1.1em;
        }
        .label {
            font-weight: bold;
            color: #ffd700;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            font-size: 0.9em;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Nomad Demo Webserver</h1>
        <p style="text-align: center; font-size: 1.2em;">Serveur web de démonstration</p>
        
        <div class="info">
            <div class="info-item">
                <span class="label">Job:</span> {{ env "NOMAD_JOB_NAME" }}
            </div>
            <div class="info-item">
                <span class="label">Allocation:</span> {{ env "NOMAD_ALLOC_ID" }}
            </div>
            <div class="info-item">
                <span class="label">Node:</span> {{ env "NOMAD_ALLOC_NAME" }}
            </div>
            <div class="info-item">
                <span class="label">Port:</span> {{ env "NOMAD_PORT_http" }}
            </div>
            <div class="info-item">
                <span class="label">Datacenter:</span> {{ env "NOMAD_DC" }}
            </div>
        </div>
        
        <div class="footer">
            <p>✅ Ce serveur est déployé et géré par HashiCorp Nomad</p>
        </div>
    </div>
</body>
</html>
EOF
        destination = "local/index.html"
      }
      
      # Ressources allouées
      resources {
        cpu    = 100  # MHz
        memory = 128  # MB
      }
      
      # Health check
      service {
        name = "demo-webserver"
        port = "http"
        
        tags = [
          "web",
          "demo",
          "nginx"
        ]
        
        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

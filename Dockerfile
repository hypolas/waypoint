FROM nginx:alpine

# Copier le template HTML qui sera remplacé par Nomad
COPY index.html /usr/share/nginx/html/index.html

# Exposer le port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

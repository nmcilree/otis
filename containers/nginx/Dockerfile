FROM nginx:1.17.2-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx.conf /etc/nginx/conf.d
# Copy SSL certificates here
# COPY ./fullchain.pem /etc/nginx/fullchain.pem
# COPY ./privkey.pem /etc/nginx/privkey.pem

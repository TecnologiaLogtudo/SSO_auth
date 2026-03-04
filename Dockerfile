FROM quay.io/keycloak/keycloak:24.0 as builder

# Configurações de Build (Imutáveis)
ENV KC_DB=postgres
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
# Desabilita XA transactions para melhor performance com Postgres padrão
ENV KC_TRANSACTION_XA_ENABLED=false

WORKDIR /opt/keycloak
# Executa o build para gerar as classes otimizadas
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:24.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Define o entrypoint e o comando otimizado
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]

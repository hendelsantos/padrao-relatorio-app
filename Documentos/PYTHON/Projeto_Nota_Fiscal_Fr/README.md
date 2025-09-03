# Controle de Nota Fiscal para MIGO (Frontend)

Este projeto contém apenas o frontend (HTML, CSS e JavaScript puro) para o sistema de controle de recebimento de Notas Fiscais (NFs) por departamento, preparado para integração com um backend em Flask e banco de dados MySQL.

## Páginas
- `index.html`: Dashboard com cartões dos departamentos (T001 a T005).
- `departamento.html`: Página de controle de um departamento com formulário de cadastro e tabela de NFs.

## Integração prevista com Backend (Flask)
Endpoints esperados (conforme especificação):
- `GET /` → renderizará `index.html`.
- `GET /departamento/<codigo_dpto>` → renderizará `departamento.html` com as NFs do departamento e poderá injetar `window.__NOTAS_INICIAIS__` no HTML.
- `POST /api/notas` → cadastro de NF (form-data com arquivo PDF).
- `PATCH /api/notas/<id_nota>/migo` → atualização do status MIGO e número.
- `GET /download/nf/<id_nota>` → download do PDF.

O frontend já chama estes endpoints através de `assets/js/api.js`. Enquanto o backend não estiver disponível, há um modo "mock" usando `localStorage` para testes visuais (sem upload real de arquivos).

## Estrutura de pastas
- `index.html`
- `departamento.html`
- `assets/`
  - `css/styles.css`
  - `js/api.js`
  - `js/main.js`
  - `js/departamento.js`

## Configuração de ambiente no Frontend
Defina a URL base da API via variável global antes de carregar `api.js` (opcional para desenvolvimento local):

```html
<script>
  window.APP_CONFIG = {
    API_BASE_URL: '' // vazio ou ex: 'http://localhost:5000'
  };
  // Opcional: forçar mock
  // window.APP_CONFIG.MOCK = true;
  // Opcional: preencher notas iniciais quando servir a página do departamento via Flask
  // window.__NOTAS_INICIAIS__ = [];
</script>
```

Se `API_BASE_URL` estiver vazio, o frontend entra em modo "mock".

## Fluxo de dados
- Cadastro: o formulário usa `FormData` e envia para `POST /api/notas` com os campos especificados e o arquivo PDF.
- Listagem: a página do departamento renderiza NFs de `window.__NOTAS_INICIAIS__` (quando injetado pelo Flask) ou do modo mock.
- MIGO: checkbox e campo "Nº da MIGO" disparam `PATCH /api/notas/:id/migo`.
- Download: o link aponta para `GET /download/nf/:id` quando há backend. No modo mock, o download é desabilitado.

## Próximos passos (para backend)
- Servir `index.html` em `/` e `departamento.html` em `/departamento/<codigo>`.
- Injetar `window.__NOTAS_INICIAIS__ = [...]` no HTML do departamento para renderização inicial.
- Implementar os endpoints `POST /api/notas`, `PATCH /api/notas/:id/migo` e `GET /download/nf/:id`.
- Garantir CORS quando servir frontend fora do Flask (apenas em desenvolvimento).

## Desenvolvimento local (somente frontend)
Abra `index.html` no navegador. O modo mock permitirá navegar e testar a UI. Para rotas reais (`/departamento/T001`), o Flask deverá servir a página.

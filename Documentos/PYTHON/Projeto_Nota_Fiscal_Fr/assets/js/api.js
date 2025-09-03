/* Camada de acesso à API e modo mock */
(function(){
  const cfg = (window.APP_CONFIG = window.APP_CONFIG || {});
  const BASE_URL = (cfg.API_BASE_URL || '').trim();
  const FORCE_MOCK = cfg.MOCK === true;
  const isMock = FORCE_MOCK || BASE_URL === '';

  function toJSON(res){ if(!res.ok) throw new Error(`HTTP ${res.status}`); return res.json(); }

  // ----------------- MOCK STORE (localStorage) -----------------
  const LS_KEY = 'mock_notas_fiscais_v1';
  let mockDb = { seq: 1, notas: [] };
  try { const raw = localStorage.getItem(LS_KEY); if(raw) mockDb = JSON.parse(raw); } catch {}
  function persist(){ localStorage.setItem(LS_KEY, JSON.stringify(mockDb)); }

  function mockListar(codigo){
    const list = mockDb.notas.filter(n => n.departamento_cod === codigo);
    // Simular ordenação por data de criação desc
    return Promise.resolve(list.sort((a,b) => (b.data_criacao || 0) - (a.data_criacao || 0)));
  }
  function mockCriar(data){
    const id = mockDb.seq++;
    const now = Date.now();
    const item = { id, data_criacao: now, migo_realizada: false, numero_migo: null, caminho_pdf: null, ...data };
    mockDb.notas.push(item); persist();
    return Promise.resolve(item);
  }
  function mockAtualizarMigo(id, payload){
    const idx = mockDb.notas.findIndex(n => n.id === id);
    if(idx < 0) return Promise.reject(new Error('NF não encontrada'));
    mockDb.notas[idx] = { ...mockDb.notas[idx], ...payload }; persist();
    return Promise.resolve(mockDb.notas[idx]);
  }

  // ----------------- REAL API -----------------
  function apiListar(codigo){
    // Backend pode servir a lista no próprio render (window.__NOTAS_INICIAIS__), mas mantemos uma rota REST se necessário
    return fetch(`${BASE_URL}/departamento/${encodeURIComponent(codigo)}/json`).then(toJSON);
  }
  function apiCriar(formData){
    return fetch(`${BASE_URL}/api/notas`, { method: 'POST', body: formData }).then(toJSON);
  }
  function apiAtualizarMigo(id, payload){
    return fetch(`${BASE_URL}/api/notas/${id}/migo`, { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) }).then(toJSON);
  }

  // ----------------- PUBLIC API -----------------
  window.FrontendAPI = {
    isMock,
    listarNotasDepartamento: function(codigo){
      if(isMock){ return mockListar(codigo); }
      // fallback: se backend injetar dados no HTML
      if(Array.isArray(window.__NOTAS_INICIAIS__)) return Promise.resolve(window.__NOTAS_INICIAIS__);
      return apiListar(codigo);
    },
    criarNota: function(payload){
      if(isMock){
        // arquivo não é salvo em mock
        const { arquivo_pdf, ...rest } = payload;
        return mockCriar(rest);
      }
      const fd = new FormData();
      Object.entries(payload).forEach(([k,v]) => {
        if(v === undefined || v === null) return;
        if(k === 'arquivo_pdf') fd.append('arquivo_pdf', v);
        else fd.append(k, v);
      });
      return apiCriar(fd);
    },
    atualizarMigo: function(id, { migo_realizada, numero_migo }){
      if(isMock){
        return mockAtualizarMigo(Number(id), { migo_realizada: !!migo_realizada, numero_migo: numero_migo || null });
      }
      return apiAtualizarMigo(id, { migo_realizada: !!migo_realizada, numero_migo: numero_migo || null });
    },
    downloadUrl: function(id){
      if(isMock) return null; // sem download real no mock
      return `${BASE_URL}/download/nf/${id}`;
    }
  };
})();

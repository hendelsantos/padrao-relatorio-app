(function(){
  const qs = new URLSearchParams(location.search);
  const codigo = qs.get('codigo') || 'T001'; // fallback simples
  const titulo = document.getElementById('titulo-departamento');
  if(titulo) titulo.textContent = `Departamento ${codigo}`;

  const form = document.getElementById('form-nf');
  const mensagens = document.getElementById('mensagens');
  const tabelaBody = document.querySelector('#tabela-notas tbody');

  function setMsg(text, ok){
    mensagens.textContent = text || '';
    mensagens.className = 'mensagens ' + (ok ? 'mensagem-ok' : text ? 'mensagem-erro' : '');
  }

  function linhaNF(n){
    const tr = document.createElement('tr');

    const tdEmissao = document.createElement('td');
    tdEmissao.textContent = n.data_emissao || '';

    const tdNumero = document.createElement('td');
    const inputNumero = document.createElement('input');
    inputNumero.type = 'text';
    inputNumero.value = n.numero_nf || '';
    inputNumero.className = 'input-editar-nf';
    inputNumero.title = 'Editar número da NF';
    inputNumero.addEventListener('change', function(){
      window.FrontendAPI.atualizarMigo(n.id, { numero_nf: inputNumero.value.trim() })
        .then(()=> setMsg('Número da NF atualizado!', true))
        .catch(err=> setMsg('Falha ao atualizar número da NF: ' + (err.message || err), false));
    });
    tdNumero.appendChild(inputNumero);

    const tdFornecedor = document.createElement('td');
    tdFornecedor.textContent = n.fornecedor || '';

    const tdPedidos = document.createElement('td');
    const inputPedidos = document.createElement('input');
    inputPedidos.type = 'text';
    inputPedidos.value = n.pedidos || '';
    inputPedidos.className = 'input-editar-nf';
    inputPedidos.title = 'Editar pedidos';
    inputPedidos.addEventListener('change', function(){
      window.FrontendAPI.atualizarMigo(n.id, { pedidos: inputPedidos.value.trim() })
        .then(()=> setMsg('Pedidos atualizados!', true))
        .catch(err=> setMsg('Falha ao atualizar pedidos: ' + (err.message || err), false));
    });
    tdPedidos.appendChild(inputPedidos);

    const tdReceb = document.createElement('td');
    tdReceb.textContent = n.data_recebimento || '';

    const tdMigoStatus = document.createElement('td');
    const statusWrap = document.createElement('label');
    statusWrap.className = 'status-migo';
    const chk = document.createElement('input');
    chk.type = 'checkbox';
    chk.checked = !!n.migo_realizada;
    const spanLbl = document.createElement('span');
    spanLbl.textContent = 'Realizada';
    statusWrap.appendChild(chk);
    statusWrap.appendChild(spanLbl);
    tdMigoStatus.appendChild(statusWrap);

    const tdMigoNum = document.createElement('td');
    const inputMigo = document.createElement('input');
    inputMigo.type = 'text';
    inputMigo.className = 'input-migo';
    inputMigo.placeholder = 'Opcional';
    inputMigo.value = n.numero_migo || '';
    tdMigoNum.appendChild(inputMigo);

    const tdAcoes = document.createElement('td');
    const link = document.createElement('a');
    const url = window.FrontendAPI.downloadUrl(n.id);
    link.textContent = 'Baixar PDF';
    if(url){ link.href = url; link.target = '_blank'; }
    else { link.href = 'javascript:void(0)'; link.style.opacity = .6; link.title = 'Indisponível no modo mock'; }
    tdAcoes.appendChild(link);

    // Eventos de atualização MIGO
    function enviarAtualizacao(){
      window.FrontendAPI.atualizarMigo(n.id, { migo_realizada: chk.checked, numero_migo: inputMigo.value.trim() })
        .then(()=> setMsg('Atualizado com sucesso.', true))
        .catch(err=> setMsg('Falha ao atualizar MIGO: ' + (err.message || err), false));
    }
    chk.addEventListener('change', enviarAtualizacao);
    inputMigo.addEventListener('change', enviarAtualizacao);

    tr.appendChild(tdEmissao);
    tr.appendChild(tdNumero);
    tr.appendChild(tdFornecedor);
    tr.appendChild(tdPedidos);
    tr.appendChild(tdReceb);
    tr.appendChild(tdMigoStatus);
    tr.appendChild(tdMigoNum);
    tr.appendChild(tdAcoes);
    return tr;
  }

  function renderLista(notas){
    tabelaBody.innerHTML = '';
    notas.forEach(n => tabelaBody.appendChild(linhaNF(n)));
  }

  function carregar(){
    window.FrontendAPI.listarNotasDepartamento(codigo)
      .then(renderLista)
      .catch(err => setMsg('Erro ao carregar notas: ' + (err.message || err), false));
  }

  form.addEventListener('submit', function(e){
    e.preventDefault();
    setMsg('');

    const data = new FormData(form);
    const payload = {
      data_emissao: data.get('data_emissao'),
      numero_nf: data.get('numero_nf'),
      fornecedor: data.get('fornecedor'),
      pedidos: data.get('pedidos'),
      data_recebimento: data.get('data_recebimento'),
      arquivo_pdf: data.get('arquivo_pdf'),
      departamento_cod: codigo
    };

    // Validações mínimas de front
    if(!payload.arquivo_pdf || (payload.arquivo_pdf && payload.arquivo_pdf.type && payload.arquivo_pdf.type.indexOf('pdf') === -1)){
      setMsg('Selecione um arquivo PDF válido.', false);
      return;
    }

    const btn = form.querySelector('button[type="submit"]');
    btn.disabled = true;

    window.FrontendAPI.criarNota(payload)
      .then(n => {
        setMsg('Nota cadastrada com sucesso!', true);
        // no modo real, `n` deve ter id; no mock também
        carregar();
        form.reset();
      })
      .catch(err => setMsg('Falha ao salvar: ' + (err.message || err), false))
      .finally(()=> btn.disabled = false);
  });

  // Inicialização
  carregar();
})();

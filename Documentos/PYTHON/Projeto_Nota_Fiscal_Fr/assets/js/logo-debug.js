// 🔧 Script para debug do logo - adicione no console do navegador

(function testLogo() {
  console.log('🧪 TESTE DE LOGO - Debug Completo\n');
  
  // 1. Verificar se o arquivo logo existe
  const paths = [
    '/assets/img/logo.png',
    './assets/img/logo.png', 
    'assets/img/logo.png',
    '../assets/img/logo.png'
  ];
  
  console.log('📂 Testando caminhos de logo:');
  
  paths.forEach((path, i) => {
    const img = new Image();
    img.onload = () => {
      console.log(`✅ ${i+1}. SUCESSO: ${path}`);
      console.log(`   Dimensões: ${img.width}x${img.height}px`);
      
      // Aplica o logo encontrado
      document.documentElement.style.setProperty('--logo-found', `url(${path})`);
      
      // Força aplicação
      const style = document.createElement('style');
      style.id = 'logo-force-' + i;
      style.textContent = `
        body::before { 
          background-image: url(${path}) !important;
          opacity: 0.15 !important;
          filter: blur(3px) brightness(0.6) !important;
        }
      `;
      document.head.appendChild(style);
    };
    
    img.onerror = () => {
      console.log(`❌ ${i+1}. FALHA: ${path}`);
    };
    
    img.src = path + '?debug=' + Date.now();
  });
  
  // 2. Verificar CSS atual
  setTimeout(() => {
    console.log('\n🎨 ANÁLISE DE CSS:');
    const body = document.body;
    const computedStyle = getComputedStyle(body, '::before');
    
    console.log('Background-image:', computedStyle.backgroundImage);
    console.log('Opacity:', computedStyle.opacity);
    console.log('Filter:', computedStyle.filter);
    console.log('Z-index:', computedStyle.zIndex);
    console.log('Position:', computedStyle.position);
    
    // 3. Verificar variáveis CSS
    const rootStyle = getComputedStyle(document.documentElement);
    console.log('\n🔧 VARIÁVEIS CSS:');
    console.log('--logo-opacity:', rootStyle.getPropertyValue('--logo-opacity'));
    console.log('--logo-blur:', rootStyle.getPropertyValue('--logo-blur'));
    console.log('--logo-size:', rootStyle.getPropertyValue('--logo-size'));
    
    // 4. Força aplicação manual se necessário
    console.log('\n🚀 APLICAÇÃO MANUAL:');
    const testStyle = document.createElement('style');
    testStyle.id = 'logo-debug-final';
    testStyle.textContent = `
      body::before { 
        content: '' !important;
        position: fixed !important;
        inset: 0 !important;
        background: url('/assets/img/logo.png') no-repeat center/60vmin !important;
        opacity: 0.12 !important;
        filter: blur(2px) brightness(0.5) !important;
        z-index: -1 !important;
        pointer-events: none !important;
      }
    `;
    document.head.appendChild(testStyle);
    console.log('✨ Estilo manual aplicado!');
    
  }, 1000);
  
  // 5. Status final
  setTimeout(() => {
    console.log('\n📊 RESULTADO FINAL:');
    console.log('- Verifique se o logo está visível no fundo');
    console.log('- Deve estar bem sutil (12% opacidade)');
    console.log('- Com leve blur e escurecido');
    console.log('\n🔍 Se ainda não aparecer:');
    console.log('1. Verifique se logo.png existe na pasta assets/img/');
    console.log('2. Teste abrindo só o logo: http://localhost:8080/assets/img/logo.png');
    console.log('3. Use F12 > Elements para ver o CSS do body::before');
  }, 2000);
  
})();

// Para testar manualmente:
// testLogo();

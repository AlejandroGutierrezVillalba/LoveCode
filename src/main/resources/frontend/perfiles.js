const API = 'http://localhost:8080';
let perfiles = [];
let indiceActual = 0;

async function cargarPerfiles() {
    try {
        const response = await fetch(`${API}/usuarios`);
        perfiles = await response.json();
        mostrarPerfil();
    } catch (error) {
        console.error('Error al cargar perfiles:', error);
    }
}

function mostrarPerfil() {
    const stack = document.getElementById('card-stack');
    const noMore = document.getElementById('no-more');

    if (indiceActual >= perfiles.length) {
        stack.style.display = 'none';
        noMore.style.display = 'block';
        return;
    }

    const perfil = perfiles[indiceActual];
    const iniciales = perfil.nombre.substring(0, 2).toUpperCase();

    stack.innerHTML = `
        <div class="profile-card">
            <div class="card-header">
                <div class="avatar">${iniciales}</div>
                <div>
                    <p class="card-name">${perfil.nombre}</p>
                    <p class="card-ciudad">📍 ${perfil.ciudad || 'Sin ciudad'}</p>
                </div>
            </div>
            <p class="card-descripcion">${perfil.descripcion || 'Sin descripción'}</p>
            <div class="card-actions">
                <button class="btn-dislike" onclick="pasarPerfil()">✕</button>
                <button class="btn-like" onclick="darLike(${perfil.idUsuario})">♥</button>
            </div>
        </div>
    `;
}

function pasarPerfil() {
    indiceActual++;
    mostrarPerfil();
}

async function darLike(idDestino) {
    const idOrigen = localStorage.getItem('usuario_id');

    if (!idOrigen) {
        window.location.href = 'login.html';
        return;
    }

    try {
        const response = await fetch(`${API}/likes?idOrigen=${idOrigen}&idDestino=${idDestino}`, {
            method: 'POST'
        });
        const texto = await response.text();

        if (texto.includes('match')) {
            alert('¡Tienes un nuevo match! 🎉');
        }
    } catch (error) {
        console.error('Error al dar like:', error);
    }

    indiceActual++;
    mostrarPerfil();
}

document.getElementById('logout-btn').addEventListener('click', function() {
    localStorage.removeItem('usuario_id');
    localStorage.removeItem('usuario_email');
    localStorage.removeItem('usuario_nombre');
    window.location.href = 'index.html';
});

cargarPerfiles();
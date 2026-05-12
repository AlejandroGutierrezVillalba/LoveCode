const API = 'http://localhost:8080';

async function cargarMatches() {
    const noMatches = document.getElementById('no-matches');
    const matchesList = document.getElementById('matches-list');

    try {
        const response = await fetch(`${API}/matches/1`);
        const matches = await response.json();

        if (!matches || matches.length === 0) {
            noMatches.style.display = 'block';
            return;
        }

        matches.forEach(match => {
            const usuario1 = match[0];
            const usuario2 = match[1];
            const fecha = match[2];
            const iniciales = usuario2.substring(0, 2).toUpperCase();

            const card = document.createElement('div');
            card.className = 'match-card';
            card.innerHTML = `
                <div class="match-avatar">${iniciales}</div>
                <div class="match-info">
                    <p class="match-name">${usuario2}</p>
                    <p class="match-tech">Match con ${usuario1}</p>
                </div>
                <div class="match-date">${fecha ? fecha.substring(0, 10) : ''}</div>
            `;
            matchesList.appendChild(card);
        });

    } catch (error) {
        console.error('Error al cargar matches:', error);
        noMatches.style.display = 'block';
    }
}

document.getElementById('logout-btn').addEventListener('click', function() {
    localStorage.removeItem('usuario_email');
    window.location.href = 'index.html';
});

cargarMatches();
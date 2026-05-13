const API = 'http://localhost:8080';
let seleccionadas = {};

async function cargarTecnologias() {
    try {
        const response = await fetch(`${API}/tecnologias`);
        const tecnologias = await response.json();

        const grupos = {};
        tecnologias.forEach(t => {
            const categoria = t[2];
            if (!grupos[categoria]) grupos[categoria] = [];
            grupos[categoria].push({ id: t[0], nombre: t[1] });
        });

        const lista = document.getElementById('tech-list');
        lista.innerHTML = '';

        Object.entries(grupos).forEach(([categoria, techs]) => {
            const grupo = document.createElement('div');
            grupo.className = 'categoria-grupo';
            grupo.innerHTML = `<h3>${categoria}</h3><div class="categoria-tags"></div>`;

            const tagsContainer = grupo.querySelector('.categoria-tags');

            techs.forEach(tech => {
                const item = document.createElement('div');
                item.className = 'tech-item';
                item.innerHTML = `
                    <button class="tech-btn" data-id="${tech.id}" onclick="toggleTech(this, '${tech.id}')">
                        ${tech.nombre}
                    </button>
                    <select class="nivel-select" id="nivel-${tech.id}">
                        <option value="principiante">Principiante</option>
                        <option value="basico">Básico</option>
                        <option value="intermedio">Intermedio</option>
                        <option value="avanzado">Avanzado</option>
                    </select>
                `;
                tagsContainer.appendChild(item);
            });

            lista.appendChild(grupo);
        });

    } catch (error) {
        console.error('Error al cargar tecnologias:', error);
    }
}

function toggleTech(btn, id) {
    btn.classList.toggle('selected');
    const nivelSelect = document.getElementById(`nivel-${id}`);

    if (btn.classList.contains('selected')) {
        seleccionadas[id] = 'principiante';
        nivelSelect.classList.add('visible');
        nivelSelect.addEventListener('change', function() {
            seleccionadas[id] = this.value;
        });
    } else {
        delete seleccionadas[id];
        nivelSelect.classList.remove('visible');
    }
}

document.getElementById('guardar-btn').addEventListener('click', async function() {
    const errorMsg = document.getElementById('error-msg');
    const idUsuario = localStorage.getItem('usuario_id');

    if (Object.keys(seleccionadas).length === 0) {
        errorMsg.style.display = 'block';
        return;
    }

    errorMsg.style.display = 'none';

    try {
        for (const [idTecnologia, nivel] of Object.entries(seleccionadas)) {
            await fetch(`${API}/tecnologias/usuario/${idUsuario}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ idTecnologia, nivel })
            });
        }
        window.location.href = 'perfiles.html';
    } catch (error) {
        console.error('Error al guardar tecnologias:', error);
    }
});

cargarTecnologias();
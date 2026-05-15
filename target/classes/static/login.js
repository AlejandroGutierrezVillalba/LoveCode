document.getElementById('login-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const errorMsg = document.getElementById('error-msg');

    try {
        const response = await fetch('http://localhost:8080/usuarios/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        const texto = await response.text();

        if (texto.startsWith('OK:')) {
            const partes = texto.split(':');
            localStorage.setItem('usuario_id', partes[1]);
            localStorage.setItem('usuario_nombre', partes[2]);
            localStorage.setItem('usuario_email', email);
            window.location.href = 'perfiles.html';

        } else if (texto.startsWith('INACTIVO:')) {
            const id = texto.split(':')[1];
            errorMsg.innerHTML = `Tu cuenta está desactivada. 
                <a href="#" onclick="reactivar(${id})">¿Quieres reactivarla?</a>`;
            errorMsg.style.display = 'block';

        } else {
            errorMsg.textContent = 'Email o contraseña incorrectos.';
            errorMsg.style.display = 'block';
        }
    } catch (error) {
        errorMsg.textContent = 'Error de conexión con el servidor.';
        errorMsg.style.display = 'block';
        console.error('Error:', error);
    }
});

async function reactivar(id) {
    try {
        const response = await fetch(`http://localhost:8080/usuarios/${id}/reactivar`, {
            method: 'PUT'
        });
        const texto = await response.text();
        if (texto === 'OK') {
            alert('Cuenta reactivada correctamente. Inicia sesión de nuevo.');
            document.getElementById('error-msg').style.display = 'none';
        }
    } catch (error) {
        console.error('Error al reactivar:', error);
    }
}
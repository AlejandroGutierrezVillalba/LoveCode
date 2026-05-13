document.getElementById('register-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    const nombre = document.getElementById('nombre').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const ciudad = document.getElementById('ciudad').value;
    const descripcion = document.getElementById('descripcion').value;
    const errorMsg = document.getElementById('error-msg');

    try {
        const response = await fetch('http://localhost:8080/usuarios/registro', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ nombre, email, password, ciudad, descripcion })
        });

        const texto = await response.text();

        if (texto.startsWith('OK:')) {
            const id = texto.split(':')[1];
            localStorage.setItem('usuario_id', id);
            localStorage.setItem('usuario_email', email);
            window.location.href = 'tecnologias.html';
        } else {
            errorMsg.style.display = 'block';
        }
    } catch (error) {
        errorMsg.style.display = 'block';
        console.error('Error:', error);
    }
});
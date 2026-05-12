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

        if (texto.includes('Login correcto')) {
            // Guardamos el email para usarlo luego en perfiles
            localStorage.setItem('usuario_email', email);
            window.location.href = 'perfiles.html';
        } else {
            errorMsg.style.display = 'block';
        }
    } catch (error) {
        errorMsg.style.display = 'block';
        console.error('Error:', error);
    }
});
-- ⚠️ PENGINGAT: Menjalankan script ini akan menghapus seluruh data pada tabel:
-- messages, chat_rooms, favorites, orders, products, users, serta akun auth users!

-- 1. Kosongkan semua data tabel public dan auth
TRUNCATE auth.users CASCADE;
TRUNCATE public.users CASCADE;
TRUNCATE public.products CASCADE;
TRUNCATE public.orders CASCADE;
TRUNCATE public.favorites CASCADE;
TRUNCATE public.chat_rooms CASCADE;
TRUNCATE public.messages CASCADE;

-- 2. Buat akun Admin baru dengan aman menggunakan Transaksi DO block
DO $$
DECLARE
  admin_uid UUID := 'd04f6534-58e1-4c6e-8d8a-7848c6b7582b'; -- UUID Tetap Admin
  admin_email VARCHAR := 'admin@reloved.com';
  admin_name VARCHAR := 'Admin Reloved';
  encrypted_pass VARCHAR;
BEGIN
  -- Generate hash bcrypt aman untuk password 'admin123' menggunakan extension pgcrypto bawaan Postgres
  encrypted_pass := crypt('admin123', gen_salt('bf', 10));

  -- 3. Masukkan ke tabel Auth Supabase (auth.users)
  INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
  ) VALUES (
    '00000000-0000-0000-0000-000000000000',
    admin_uid,
    'authenticated',
    'authenticated',
    admin_email,
    encrypted_pass,
    now(),
    '{"provider": "email", "providers": ["email"]}',
    jsonb_build_object('name', admin_name),
    now(),
    now(),
    '',
    '',
    '',
    ''
  );

  -- 4. Sinkronisasikan dengan tabel auth.identities
  INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at
  ) VALUES (
    admin_uid,
    admin_uid,
    jsonb_build_object('sub', admin_uid, 'email', admin_email),
    'email',
    admin_uid, -- Menyediakan provider_id (UID admin)
    now(),
    now(),
    now()
  );

  -- 5. Masukkan ke tabel profil public.users di aplikasi Reloved
  -- Menyetel kolom role = 'admin' agar mendapat hak akses dasbor admin
  INSERT INTO public.users (
    id,
    email,
    name,
    role,
    phone,
    bio
  ) VALUES (
    admin_uid,
    admin_email,
    admin_name,
    'admin',
    '08123456789',
    'Administrator Utama Reloved'
  );

  RAISE NOTICE 'Database berhasil di-reset! Akun Admin berhasil dibuat: admin@reloved.com / admin123';
END $$;

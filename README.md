# Evolution API - جاهز للرفع على Render

مشروع جاهز لنشر **Evolution API** على **Render.com** مجانًا (مع قيود الـ Free Tier).

Evolution API تتيح لك عمل بوت واتساب باستخدام رقمك الشخصي عبر مسح QR Code (مثل واتساب ويب).

> ⚠️ **تحذير مهم**: هذه الطريقة غير رسمية وتخالف شروط واتساب. يوجد خطر حظر الرقم. استخدم رقم ثانوي للتجربة.

---

## المتطلبات

- حساب على [Render.com](https://render.com) (مجاني)
- حساب GitHub (لديك هذا المشروع)
- رقم واتساب (يفضل ثانوي)

---

## طريقة النشر على Render (موصى بها)

### الخطوة 1: Fork أو Clone المشروع

1. اذهب إلى هذا المستودع: [https://github.com/2gps/evolution-api-render](https://github.com/2gps/evolution-api-render)
2. اضغط **Fork** لو تبي تعدل عليه، أو استخدمه مباشرة.

### الخطوة 2: إنشاء الخدمات على Render

#### أ) إنشاء PostgreSQL (Database)

1. في Render Dashboard → **New** → **PostgreSQL**
2. Name: `evolution-db`
3. Database: `evolution`
4. User: `evolution`
5. Plan: **Free**
6. اضغط **Create Database**
7. انتظر حتى يصبح Ready، ثم انسخ **Internal Database URL**

#### ب) إنشاء Redis (Key Value)

1. **New** → **Key Value**
2. Name: `evolution-redis`
3. Plan: **Free**
4. اضغط **Create**
5. انسخ **Internal Redis URL** (يبدأ بـ `redis://`)

#### ج) إنشاء Web Service (Evolution API)

1. **New** → **Web Service**
2. Connect the repository `2gps/evolution-api-render` (أو الـ Fork الخاص بك)
3. الإعدادات:
   - **Name**: `evolution-api`
   - **Region**: اختر الأقرب لك
   - **Runtime**: Docker
   - **Dockerfile Path**: `./Dockerfile`
   - **Plan**: Free
4. في **Environment Variables** أضف التالي:

| Key                        | Value                                      |
|---------------------------|--------------------------------------------|
| `SERVER_URL`              | `https://اسم-الخدمة-الخاص-بك.onrender.com` |
| `AUTHENTICATION_API_KEY`  | مفتاح قوي عشوائي (مثال: `openssl rand -hex 32`) |
| `DATABASE_PROVIDER`       | `postgresql`                               |
| `DATABASE_CONNECTION_URI` | Internal Database URL من الخطوة أ          |
| `CACHE_REDIS_ENABLED`     | `true`                                     |
| `CACHE_REDIS_URI`         | Internal Redis URL من الخطوة ب             |
| `CACHE_LOCAL_ENABLED`     | `false`                                    |
| `DEL_INSTANCE`            | `false`                                    |
| `LOG_LEVEL`               | `ERROR,WARN,INFO`                          |
| `CONFIG_SESSION_PHONE_CLIENT` | `My WhatsApp Bot`                      |
| `CONFIG_SESSION_PHONE_NAME`   | `Chrome`                               |

5. اضغط **Create Web Service**

---

## بعد النشر

1. انتظر حتى ينتهي البناء (Build) ويصبح الـ Service **Live**.
2. افتح الرابط: `https://your-service.onrender.com`
3. يجب أن ترى رسالة أو صفحة Evolution API.

### إنشاء Instance وربط الرقم

استخدم أي أداة مثل Postman أو curl أو الكود التالي:

```bash
curl -X POST https://your-service.onrender.com/instance/create \
  -H "apikey: YOUR_AUTHENTICATION_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "mybot",
    "qrcode": true,
    "integration": "WHATSAPP-BAILEYS"
  }'
```

- الرد سيعطي `qrcode.base64` أو كود.
- افتح واتساب على جوالك → **الأجهزة المرتبطة** → **ربط جهاز** → امسح الـ QR.

### التحقق من الحالة

```bash
curl https://your-service.onrender.com/instance/connectionState/mybot \
  -H "apikey: YOUR_AUTHENTICATION_API_KEY"
```

---

## ملاحظات مهمة عن Free Tier في Render

| العنصر          | التفاصيل                                      |
|-----------------|-----------------------------------------------|
| Web Service     | ينام بعد 15 دقيقة عدم نشاط (Cold Start ~30-60 ثانية) |
| PostgreSQL      | مجاني لمدة **30 يوم فقط** ثم ينتهي           |
| Redis (Key Value)| مجاني، لكن البيانات تُمسح عند إعادة التشغيل  |
| الساعات         | 750 ساعة/شهر                                  |

**نصيحة**: للتجربة الشخصية هذا كافي. لو تبي شيء دائم، انتقل لخطة مدفوعة أو استخدم VPS رخيص (Hetzner / Contabo / Oracle Free).

---

## أوامر مفيدة بعد الربط

**إرسال رسالة نصية:**

```bash
curl -X POST https://your-service.onrender.com/message/sendText/mybot \
  -H "apikey: YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "9665xxxxxxxx",
    "text": "مرحبا من البوت!"
  }'
```

**جلب كل الـ Instances:**

```bash
curl https://your-service.onrender.com/instance/fetchInstances \
  -H "apikey: YOUR_KEY"
```

---

## ربط مع n8n أو Typebot (اختياري)

بعد ما يصير الـ API شغال، تقدر تربطه مع:

- **n8n** (أتمتة بدون كود)
- **Typebot**
- أي سكريبت Python / Node.js

استخدم الـ Webhook في Evolution API لاستقبال الرسائل.

---

## روابط مفيدة

- [التوثيق الرسمي لـ Evolution API](https://doc.evolution-api.com)
- [GitHub الرسمي](https://github.com/evolution-foundation/evolution-api)
- [Render Docs](https://render.com/docs)

---

## تحذير قانوني

استخدام مكتبات غير رسمية مثل Baileys يخالف شروط خدمة واتساب.  
المطور غير مسؤول عن أي حظر أو مشاكل تحدث لرقمك.

استخدم على مسؤوليتك الخاصة.

---

تم تجهيز المشروع بواسطة Grok — جاهز للرفع فورًا.

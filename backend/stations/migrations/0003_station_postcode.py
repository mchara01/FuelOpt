# Generated by Django 3.2.8 on 2021-10-27 12:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('stations', '0002_auto_20211027_1055'),
    ]

    operations = [
        migrations.AddField(
            model_name='station',
            name='postcode',
            field=models.CharField(default='', max_length=12),
        ),
    ]

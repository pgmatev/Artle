from django.db import models
from django.contrib.auth.models import User
# Create your models here.


class Template(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    url = models.TextField(default=None, blank=True)
    user_thought = models.TextField(default=None, blank=True)
    is_liked = models.BooleanField(default=False)
    can_like = models.BooleanField(default=False)


class MusicQuestion(models.Model):
    question = models.TextField()


class Music(models.Model):
    template = models.OneToOneField(Template, on_delete=models.CASCADE)
    music_question = models.ForeignKey(MusicQuestion, blank=True, on_delete=models.CASCADE)


class RhymeWord(models.Model):
    word = models.CharField(max_length=128)


class Rhyme(models.Model):
    template = models.OneToOneField(Template, on_delete=models.CASCADE)
    rhyme_word = models.ForeignKey(RhymeWord, blank=True, on_delete=models.CASCADE)


class DrawingWord(models.Model):
    word = models.CharField(max_length=128)


class Drawing(models.Model):
    template = models.OneToOneField(Template, on_delete=models.CASCADE)
    drawing_word = models.ForeignKey(DrawingWord, blank=True, on_delete=models.CASCADE)


class Movie(models.Model):
    template = models.OneToOneField(Template, on_delete=models.CASCADE)


class QuoteQuestion(models.Model):
    question = models.TextField()


class Quote(models.Model):
    template = models.OneToOneField(Template, on_delete=models.CASCADE)
    music_question = models.ForeignKey(QuoteQuestion, blank=True, on_delete=models.CASCADE)

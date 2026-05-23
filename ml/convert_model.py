"""
convert_model.py
Converts a Keras `.keras` model into two SavedModel directories:
 - classification SavedModel
 - embedding SavedModel (outputs penultimate layer / pooled features)

Usage:
    python convert_model.py --input D:/Study/Ml/flower_model_best.keras --out-dir src/main/resources/models/flower_model

This script tries to be robust: it will look for a pooling or flatten layer before the final Dense.
"""
from __future__ import annotations

import argparse
from pathlib import Path
import tensorflow as tf


def find_embedding_layer(model):
    # Try to find a global pooling layer
    for layer in reversed(model.layers[:-1]):
        name = layer.__class__.__name__.lower()
        if 'global' in name or 'pool' in name or 'flatten' in name:
            return layer
    # fallback to second last layer
    return model.layers[-2]


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--input', required=True)
    p.add_argument('--out-dir', required=True)
    args = p.parse_args()

    input_path = Path(args.input)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    print('Loading Keras model from', input_path)
    model = tf.keras.models.load_model(str(input_path), compile=False)

    # classification SavedModel
    clf_dir = out_dir / 'saved_classification'
    print('Saving classification SavedModel to', clf_dir)
    tf.saved_model.save(model, str(clf_dir))

    # embedding model
    emb_layer = find_embedding_layer(model)
    print('Using embedding layer:', emb_layer.name)
    try:
        embedding_model = tf.keras.Model(inputs=model.input, outputs=emb_layer.output)
        emb_dir = out_dir / 'saved_embedding'
        print('Saving embedding SavedModel to', emb_dir)
        tf.saved_model.save(embedding_model, str(emb_dir))
    except Exception as e:
        print('Failed to build embedding model:', e)

    print('Done')


if __name__ == '__main__':
    main()
